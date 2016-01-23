USE_TMPFS := 1

TMPDIR := tmp
TMPIMGDIR := $(TMPDIR)/img
OUTDIR := $(TMPDIR)

TARGETS_DVI := $(OUTDIR)/main.dvi
TARGETS_PDF := $(OUTDIR)/main.pdf
TARGETS := $(TARGETS_DVI) $(TARGETS_PDF)

SRCS_MAIN := main.tex
SRCS := $(SRCS_MAIN) ref.bib
SRCS += $(addprefix p.ngk/, jw.s.tex)
SRCS += $(addprefix p.namikilinux/, main.s.tex)
SRCS += $(addprefix p.cctn/, main.s.tex $(addprefix img/, front.png))
SRCS += $(addprefix p.jsec/, jw.s.tex)
SRCS += $(addprefix p.libms/, main.s.tex)
SRCS += $(addprefix p.pochi/, main.s.tex $(addprefix img/, circuit.png motion.png peace.png perspective.png tilt.png wire-left.png wire-right.png wire-with-motor.png))
SRCS += $(addprefix p.server/, main.s.tex $(addprefix img/, peri-circ1.png peri-circ2.png))
SRCS += $(addprefix p.vc4/, main.tex)
SRCS += $(addprefix p.fb/, main.s.tex $(addprefix img/, out.png bcast.png))
SRCS += $(addprefix p.btk/, main.s.tex usb2bt.s.tex btktab.tex $(addprefix img/, btkorig.png btkbase.png relay1.png relay2.png btksemiall.png $(addprefix usb2bt2-, $(addprefix rn42-, comp.png))) relay-circuit.roff)

#SRCS += $(addprefix p.ibk/, main.tex)
#SRCS += $(addprefix p.hist/, main.tex)
#SRCS += $(addprefix p.centerms/, main.tex)
#SRCS += $(addprefix p.stamp/, main.tex $(addprefix img/, handwriting.png stamp1.png stamp2.png))
#SRCS += $(addprefix p.overture/, main.tex)
ALLDEPS := Makefile

LATEXMK := latexmk
GROFF := groff -p
DVIPDF := dvipdfmx
PDFTOCAIRO := pdftocairo
TOUCH := touch
MKDIR := mkdir -p
CP := cp -a
RM := rm -f
RMDIR := rmdir

# $(eval $(call set-roff-rule-core, roff-file-name, output-dir-name, eps-file-name, pdf-file-name, dvi-file-name))
define set-roff-rule-core
 OBJS_PDF_EPS += $3
 OBJS_PDF += $4
 OBJS_DVI += $5
 $(TARGETS): $3
 $3: $4 | $2
	$(PDFTOCAIRO) -eps $$< $$@
 $4: $5 | $2
	$(DVIPDF) -o $$@ $$<
 $5: $1 | $2
	$(GROFF) -Tdvi $$< >$$@
endef # set-roff-rule-core

# $(eval $(call set-roff-rule, roff-file-name))
define set-roff-rule
 $(eval $(call set-roff-rule-core, $1, $(TMPIMGDIR), \
  $$(addprefix $(TMPIMGDIR)/, $(patsubst %.roff, %.roff.dvi.pdf.eps, $(notdir $1))), \
  $$(addprefix $(TMPIMGDIR)/, $(patsubst %.roff, %.roff.dvi.pdf, $(notdir $1))), \
  $$(addprefix $(TMPIMGDIR)/, $(patsubst %.roff, %.roff.dvi, $(notdir $1)))))
endef # set-roff-rule

SRCS_ROFF := $(filter %.roff, $(SRCS))
$(foreach SRC_ROFF, $(SRCS_ROFF), $(eval $(call set-roff-rule, $(SRC_ROFF))))

all: dvi

.PHONY: dvi
dvi: $(TARGETS_DVI)

.PHONY: pdf
pdf: $(TARGETS_PDF)

$(TARGETS_DVI): $(SRCS) $(ALLDEPS) | $(TMPDIR)
	TMPDIR="$(TMPDIR)" $(LATEXMK) -dvi -pdf- -outdir="$(TMPDIR)" -auxdir="$(TMPDIR)" $(SRCS_MAIN)
ifneq '$(TMPDIR)' '$(OUTDIR)'
	$(CP) "$(addprefix $(TMPDIR)/, $(notdir $@))" "$@"
else
	$(TOUCH) "$@"
endif

$(TARGETS_PDF): $(SRCS) $(ALLDEPS) | $(TMPDIR)
	TMPDIR="$(TMPDIR)" $(LATEXMK) -pdfdvi -outdir="$(TMPDIR)" -auxdir="$(TMPDIR)" $(SRCS_MAIN)
ifneq '$(TMPDIR)' '$(OUTDIR)'
	$(CP) "$(addprefix $(TMPDIR)/, $(notdir $@))" "$@"
else
	$(TOUCH) "$@"
endif

ifneq '$(TMPDIR)' '$(OUTDIR)'
$(OUTDIR):
	$(MKDIR) "$@"
endif

.PHONY: $(TMPDIR)
$(TMPDIR):
ifeq '$(USE_TMPFS)' ''
	$(MKDIR) "$@"
else
	scripts/mount_tmp.sh
endif

$(TMPIMGDIR): | $(TMPDIR)
	$(MKDIR) "$@"

.PHONY: clean
clean:
	TMPDIR="$(TMPDIR)" $(LATEXMK) -dvi -pdf- -outdir="$(TMPDIR)" -auxdir="$(TMPDIR)" $(SRCS_MAIN) -C
	TMPDIR="$(TMPDIR)" $(LATEXMK) -pdfdvi -outdir="$(TMPDIR)" -auxdir="$(TMPDIR)" $(SRCS_MAIN) -C
	$(RM) $(TARGETS)
	$(RM) "$(TMPDIR)"/dvipdfm*
	$(RM) "$(TMPDIR)"/gs_*
	$(RM) $(OBJS_PDF_EPS)
	$(RM) $(OBJS_PDF)
	$(RM) $(OBJS_DVI)
	$(RM) $(TMPIMGDIR)

.PHONY: print-srcs
print-srcs:
	@echo "$(SRCS)"
