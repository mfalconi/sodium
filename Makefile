modules := prelude.lx
cmodules := vm.c pair.c obj.c gen.c prim.c st.c
sources := $(cmodules) module-index.c $(modules:.lx=.lxc.c)

export CFLAGS := -g -pg -Wall -Werror
#export CFLAGS := -O2 -Wall -Werror
export LDFLAGS := -pg

all: vm

#ifneq ($(MAKECMDGOALS),clean)
#ifneq ($(MAKECMDGOALS),distclean)
#ifneq ($(MAKECMDGOALS),reallyclean)
-include $(sources:.c=.d)
#endif
#endif
#endif

vm: $(sources:.c=.o)

module-index.c: $(modules)
	./gen-mod-index -o $@ $(modules:.lx=)

%.lxc.c %.lxc.h: %.lx
	./lx1c -c -o $@ $<

clean:
	rm -f vm *.o core

distclean: clean
	rm -f *.d *.pyc *.lxc

reallyclean: distclean
	rm -f *.lxc.c *.lxc.h module-index.c

# .DELETE_ON_ERROR:
.PHONY: all clean distclean reallyclean

# This tells make how to generate dependency files
%.d: %.c
	@$(SHELL) -ec '$(CC) -MM $(CPPFLAGS) $< \
	              | sed '\''s/\($*\)\.o[ :]*/\1.o $@ : /g'\'' > $@; \
				  [ -s $@ ] || rm -f $@'

