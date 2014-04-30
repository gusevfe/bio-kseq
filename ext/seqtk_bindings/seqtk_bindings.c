#include <ruby.h>
#include <kseq.h>
#include <zlib.h>

KSEQ_INIT(gzFile, gzread);

void Init_seqtk_bindings();
static VALUE kseq_wrapper_allocate(VALUE klass);
static VALUE kseq_wrapper_initialize(VALUE klass, VALUE rb_filename);
static void kseq_wrapper_deallocate(void *seq);
static VALUE kseq_wrapper_read(VALUE self);
static VALUE kseq_wrapper_name(VALUE self);
static VALUE kseq_wrapper_comment(VALUE self);
static VALUE kseq_wrapper_seq(VALUE self);
static VALUE kseq_wrapper_qual(VALUE self);

VALUE mSeqtk;
VALUE cKseq;

typedef struct {
  kseq_t *seq;
  gzFile fp;
} Kseq_Wrapper;

void Init_seqtk_bindings() {
  mSeqtk = rb_define_module("Seqtk");
  cKseq = rb_define_class_under(mSeqtk, "Kseq", rb_cObject);
  rb_define_alloc_func(cKseq, kseq_wrapper_allocate);
  rb_define_method(cKseq, "initialize", kseq_wrapper_initialize, 1);
  rb_define_method(cKseq, "read!", kseq_wrapper_read, 0);
  rb_define_method(cKseq, "name", kseq_wrapper_name, 0);
  rb_define_method(cKseq, "comment", kseq_wrapper_comment, 0);
  rb_define_method(cKseq, "seq", kseq_wrapper_seq, 0);
  rb_define_method(cKseq, "qual", kseq_wrapper_qual, 0);
}

static VALUE kseq_wrapper_allocate(VALUE klass) {
  Kseq_Wrapper *w = malloc(sizeof(Kseq_Wrapper));

  return Data_Wrap_Struct(klass, NULL, kseq_wrapper_deallocate, w);
}

static void kseq_wrapper_deallocate(void *p)
{
  Kseq_Wrapper *w = p;
  kseq_destroy(w->seq);
  gzclose(w->fp);
  free(w);
}

static VALUE kseq_wrapper_read(VALUE self) {
  int r;
  Kseq_Wrapper *w;

  Data_Get_Struct(self, Kseq_Wrapper, w);
  r = kseq_read(w->seq);

  return r >= 0 ? Qtrue : Qfalse;
}

static VALUE kseq_wrapper_initialize(VALUE self, VALUE rb_filename) {
  Kseq_Wrapper *w;

  Check_Type(rb_filename, T_STRING);
  Data_Get_Struct(self, Kseq_Wrapper, w);

  w->fp = gzopen(StringValuePtr(rb_filename), "r"); 
  w->seq = kseq_init(w->fp);

  return self;    
}

#define kseq_wrapper_field(NAME) \
  static VALUE kseq_wrapper_ ## NAME(VALUE self) { \
    Kseq_Wrapper *w; \
    Data_Get_Struct(self, Kseq_Wrapper, w);\
    if (w->seq->NAME.l) \
      return rb_str_new2(w->seq->NAME.s);\
    else \
      return Qnil;\
  }

kseq_wrapper_field(name);
kseq_wrapper_field(comment);
kseq_wrapper_field(seq);
kseq_wrapper_field(qual);
