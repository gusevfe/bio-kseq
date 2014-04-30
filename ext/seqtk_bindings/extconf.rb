require 'mkmf'

dir_config('seqtk_bindings')
find_header('zlib.h')
find_library('z', 'gzopen')
create_makefile('seqtk_bindings')
