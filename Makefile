# Makefile for Radiance bench4 benchmark scene

.SUFFIXES: .unf .pic .ppm

# the default: make the image using one rpict process
all: serial.pic serial.ppm

# option: make the image using multiple rpiece processes
smp: smp.pic smp.ppm

# option: make the image on a cluster of computers (currently unsupported)
cluster: cluster.pic cluster.ppm

# genbox test
BOXTEST = $(shell genbox mat name 1 1 1 | wc -l | xargs)
ifeq ($(BOXTEST),0)
  GENBOX = genrbox
else
  GENBOX = genbox
endif
# must process fixture.rad and cube1f.rad to account for this

# determine whether this rpict uses -pd
PDOFTEST = $(shell rpict -defaults | grep "pixel depth-of-field" | wc -l | xargs)
ifeq ($(PDOFTEST),1)
  # post-3R6P1
  PDOF = "-lr -10 -u- -pd 0.0"
else
  # 3R6P1 and earlier
  PDOF = "-lr 10"
endif

# determine whether this rpict uses -ss or -sj
SPECTEST = $(shell rpict -defaults | grep "specular sampling" | wc -l | xargs)
ifeq ($(SPECTEST),1)
  # post-4.0
  SPEC = "-ss 1.0"
else
  # 4.0 and earlier
  SPEC = "-sj 1.0"
endif


#%.ppm: %.pic
.pic.ppm:
	ra_ppm $< > $@

.unf.pic:
	pfilt -1 -e +0 -x /4 -y /4 -r .6 -m .15 $< > $@

optionsUnix: optionsbase
	echo $(SPEC) $(PDOF) | cat optionsbase - > optionsUnix

serial.unf: scene.oct viewpoint optionsUnix
	rm -f serial.unf
	time rpict @viewpoint @optionsUnix -x 2048 -y 2048 -t 60 -o serial.unf scene.oct

smp.unf: args optionsUnix viewpoint
	rm -f smp.unf smp.amb
	time ./runsmp

cluster.unf: args optionsUnix viewpoint
	echo "Cluster calculation not supported yet. Sorry!"
#	time runcluster

args: viewpoint optionsUnix scene.oct
	echo '-af smp.amb -x 2048 -y 2048 -o smp.unf scene.oct' > args

scene.oct: materials.rad scene.rad lens.obj foreground.rad lens.rad
	obj2mesh -n 15 -r 16384 lens.obj > lens.msh
	oconv -f -n 6 -r 16384 materials.rad cube2f.rad > cube2f_instance.oct
	oconv -f -n 6 -r 16384 materials.rad cube4f.rad > cube4f_instance.oct
	oconv -n 6 -r 16384 materials.rad scene.rad > scene.oct

clean:
	rm -f optionsUnix args syncfile pp serial.pic old.pic smp.pic *.oct *.unf lens.msh *.amb *.ppm
