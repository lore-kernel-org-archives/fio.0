Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:55298 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbaJDMAG (ORCPT <rfc822;fio@vger.kernel.org>);
	Sat, 4 Oct 2014 08:00:06 -0400
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XaO0K-0005oL-Me
	for fio@vger.kernel.org; Sat, 04 Oct 2014 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141004120003.BFBF140136@lyth.info>
Date: Sat,  4 Oct 2014 06:00:03 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e3b4e568b362ec8d89243609e75763b37cf81b17:

  engines/libaio: reset 'wait_start' on non-EAGAIN (2014-10-01 08:48:54 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to b220c6d6f37fc55760d66728f6f9f521ea2f9b46:

  Merge branch 'expression-parser' (2014-10-03 13:20:16 -0600)

----------------------------------------------------------------

Jens Axboe (18):
      fio: support modulus for the arithmetic parser
      Update .gitignore with auto-generated lex/yacc outputs
      exp: set float output for int modulus
      Wire up exp/test-expression-parser
      Makefile: silence fixup
      Makefile: silence make clean
      exp: fix __pow_finite being undefined
      Merge branch 'master' into expression-parser
      configure: fix for the cases where bison provides yacc
      exp: get rid of the #line bug workaround
      Makefile: PARSER_OBJS is not used anymore
      exp: update man page and HOWTO
      Makefile: properly annotate LEX/YACC parts
      exp: we don't need -ly
      Makefile: exp/fixup-buggy-yacc-output is no more
      engines/libaio: modify getevents and commit error handling
      Fio 2.1.13
      Merge branch 'expression-parser'

Stephen M. Cameron (10):
      fio: allow arithmetic expressions to be used in job files
      fio: support suffixes in expression parser
      fio: support exponentiation in expression parser
      exp: fix shift/reduce conflict complaints
      Treat colons and commas as end of input in expression parser
      verify that expression parsing code gets the right answer
      do not call fprintf from yyerror in expression parser
      enable informing arithmetic parser of implicit units
      remove unused bye symbol from arithmetic parser
      make expression parser handle scientific notation

 .gitignore                   |    2 +
 FIO-VERSION-GEN              |    2 +-
 HOWTO                        |   15 ++-
 Makefile                     |   36 ++++++-
 configure                    |   51 +++++++++
 engines/libaio.c             |   11 ++
 exp/README.md                |    7 ++
 exp/expression-parser.l      |  167 +++++++++++++++++++++++++++++
 exp/expression-parser.y      |  244 ++++++++++++++++++++++++++++++++++++++++++
 exp/test-expression-parser.c |   54 ++++++++++
 fio.1                        |   24 ++++-
 os/windows/install.wxs       |    2 +-
 parse.c                      |  109 +++++++++++++++++--
 13 files changed, 708 insertions(+), 16 deletions(-)
 create mode 100644 exp/README.md
 create mode 100644 exp/expression-parser.l
 create mode 100644 exp/expression-parser.y
 create mode 100644 exp/test-expression-parser.c

---

Diff of recent changes:

diff --git a/.gitignore b/.gitignore
index 3993a30..c9d90fb 100644
--- a/.gitignore
+++ b/.gitignore
@@ -7,3 +7,5 @@
 /config.log
 /cscope.out
 /fio
+y.tab.*
+lex.yy.c
diff --git a/FIO-VERSION-GEN b/FIO-VERSION-GEN
index d36c76d..3057fed 100755
--- a/FIO-VERSION-GEN
+++ b/FIO-VERSION-GEN
@@ -1,7 +1,7 @@
 #!/bin/sh
 
 GVF=FIO-VERSION-FILE
-DEF_VER=fio-2.1.12
+DEF_VER=fio-2.1.13
 
 LF='
 '
diff --git a/HOWTO b/HOWTO
index 693eeb1..2cecbbb 100644
--- a/HOWTO
+++ b/HOWTO
@@ -253,7 +253,20 @@ machine.
 
 This section describes in details each parameter associated with a job.
 Some parameters take an option of a given type, such as an integer or
-a string. The following types are used:
+a string. Anywhere a numeric value is required, an arithmetic expression
+may be used, provided it is surrounded by parentheses. Supported operators
+are:
+
+	addition (+)
+	subtraction (-)
+	multiplication (*)
+	division (/)
+	modulus (%)
+	exponentiation (^)
+
+For time values in expressions, units are microseconds by default. This is
+different than for time values not in expressions (not enclosed in
+parentheses). The following types are used:
 
 str	String. This is a sequence of alpha characters.
 time	Integer with possible time suffix. In seconds unless otherwise
diff --git a/Makefile b/Makefile
index 8c6c056..d735ec7 100644
--- a/Makefile
+++ b/Makefile
@@ -158,6 +158,11 @@ endif
 OBJS = $(SOURCE:.c=.o)
 
 FIO_OBJS = $(OBJS) fio.o
+
+ifdef CONFIG_ARITHMETIC
+FIO_OBJS += lex.yy.o y.tab.o
+endif
+
 GFIO_OBJS = $(OBJS) gfio.o graph.o tickmarks.o ghelpers.o goptions.o gerror.o \
 			gclient.o gcompat.o cairo_text_helpers.o printing.o
 
@@ -218,8 +223,10 @@ PROGS += $(T_PROGS)
 ifneq ($(findstring $(MAKEFLAGS),s),s)
 ifndef V
 	QUIET_CC	= @echo '   ' CC $@;
-	QUIET_LINK	= @echo '   ' LINK $@;
-	QUIET_DEP	= @echo '   ' DEP $@;
+	QUIET_LINK	= @echo ' ' LINK $@;
+	QUIET_DEP	= @echo '  ' DEP $@;
+	QUIET_YACC	= @echo ' ' YACC $@;
+	QUIET_LEX	= @echo '  ' LEX $@;
 endif
 endif
 
@@ -259,6 +266,29 @@ override CFLAGS += -DFIO_VERSION='"$(FIO_VERSION)"'
 		sed -e 's/^ *//' -e 's/$$/:/' >> $*.d
 	@rm -f $*.d.tmp
 
+ifdef CONFIG_ARITHMETIC
+lex.yy.c: exp/expression-parser.l
+	$(QUIET_LEX)$(LEX) exp/expression-parser.l
+
+lex.yy.o: lex.yy.c y.tab.h
+	$(QUIET_CC)$(CC) -o $@ $(CFLAGS) $(CPPFLAGS) -c $<
+
+y.tab.o: y.tab.c y.tab.h
+	$(QUIET_CC)$(CC) -o $@ $(CFLAGS) $(CPPFLAGS) -c $<
+
+y.tab.c: exp/expression-parser.y
+	$(QUIET_YACC)$(YACC) --no-lines -d exp/expression-parser.y
+
+y.tab.h: y.tab.c
+
+exp/test-expression-parser.o: exp/test-expression-parser.c
+	$(QUIET_CC)$(CC) -o $@ $(CFLAGS) $(CPPFLAGS) -c $<
+exp/test-expression-parser: exp/test-expression-parser.o
+	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) $< y.tab.o lex.yy.o -o $@ $(LIBS)
+
+parse.o: lex.yy.o y.tab.o
+endif
+
 init.o: FIO-VERSION-FILE init.c
 	$(QUIET_CC)$(CC) -o init.o $(CFLAGS) $(CPPFLAGS) -c init.c
 
@@ -319,7 +349,7 @@ t/dedupe: $(T_DEDUPE_OBJS)
 	$(QUIET_LINK)$(CC) $(LDFLAGS) $(CFLAGS) -o $@ $(T_DEDUPE_OBJS) $(LIBS)
 
 clean: FORCE
-	-rm -f .depend $(FIO_OBJS) $(GFIO_OBJS) $(OBJS) $(T_OBJS) $(PROGS) $(T_PROGS) core.* core gfio FIO-VERSION-FILE *.d lib/*.d crc/*.d engines/*.d profiles/*.d t/*.d config-host.mak config-host.h
+	@rm -f .depend $(FIO_OBJS) $(GFIO_OBJS) $(OBJS) $(T_OBJS) $(PROGS) $(T_PROGS) core.* core gfio FIO-VERSION-FILE *.d lib/*.d crc/*.d engines/*.d profiles/*.d t/*.d config-host.mak config-host.h y.tab.[ch] lex.yy.c exp/*.[do]
 
 distclean: clean FORCE
 	@rm -f cscope.out fio.pdf fio_generate_plots.pdf fio2gnuplot.pdf
diff --git a/configure b/configure
index 33d1327..f7d8ff9 100755
--- a/configure
+++ b/configure
@@ -1270,6 +1270,49 @@ if test "$libhdfs" = "yes" ; then
 fi
 echo "HDFS engine                   $libhdfs"
 
+# Check if we have lex/yacc available
+yacc="no"
+yacc_is_bison="no"
+lex="no"
+arith="no"
+LEX=$(which lex 2> /dev/null)
+if test -x "$LEX" ; then
+  lex="yes"
+fi
+YACC=$(which yacc 2> /dev/null)
+if test -x "$YACC" ; then
+  yacc="yes"
+else
+  YACC=$(which bison 2> /dev/null)
+  if test -x "$YACC" ; then
+    yacc="yes"
+    yacc_is_bison="yes"
+  fi
+fi
+if test "$yacc" = "yes" && test "$lex" = "yes" ; then
+  arith="yes"
+fi
+
+if test "$arith" = "yes" ; then
+cat > $TMPC << EOF
+extern int yywrap(void);
+
+int main(int argc, char **argv)
+{
+  yywrap();
+  return 0;
+}
+EOF
+
+if compile_prog "" "-ll" "lex"; then
+  LIBS="-ll $LIBS"
+else
+  arith="no"
+fi
+fi
+
+echo "lex/yacc for arithmetic       $arith"
+
 #############################################################################
 
 if test "$wordsize" = "64" ; then
@@ -1414,6 +1457,14 @@ fi
 if test "$libhdfs" = "yes" ; then
   output_sym "CONFIG_LIBHDFS"
 fi
+if test "$arith" = "yes" ; then
+  output_sym "CONFIG_ARITHMETIC"
+  if test "$yacc_is_bison" = "yes" ; then
+    echo "YACC=$YACC -y" >> $config_host_mak
+  else
+    echo "YACC=$YACC" >> $config_host_mak
+  fi
+fi
 
 if test "$zlib" = "no" ; then
   echo "Consider installing zlib-dev (zlib-devel), some fio features depend on it."
diff --git a/engines/libaio.c b/engines/libaio.c
index 31c850e..6c5d73e 100644
--- a/engines/libaio.c
+++ b/engines/libaio.c
@@ -167,6 +167,8 @@ static int fio_libaio_getevents(struct thread_data *td, unsigned int min,
 			events += r;
 		else if (r == -EAGAIN)
 			usleep(100);
+		else
+			break;
 	} while (events < min);
 
 	return r < 0 ? r : events;
@@ -283,6 +285,15 @@ static int fio_libaio_commit(struct thread_data *td)
 			}
 			usleep(1);
 			continue;
+		} else if (ret == -ENOMEM) {
+			/*
+			 * If we get -ENOMEM, reap events if we can. If
+			 * we cannot, treat it as a fatal event since there's
+			 * nothing we can do about it.
+			 */
+			if (ld->queued)
+				ret = 0;
+			break;
 		} else
 			break;
 	} while (ld->queued);
diff --git a/exp/README.md b/exp/README.md
new file mode 100644
index 0000000..48c11c9
--- /dev/null
+++ b/exp/README.md
@@ -0,0 +1,7 @@
+simple-expression-parser
+========================
+
+A simple expression parser for arithmetic expressions made with bison + flex
+
+To use, see the example test-expression-parser.c
+
diff --git a/exp/expression-parser.l b/exp/expression-parser.l
new file mode 100644
index 0000000..7d5e787
--- /dev/null
+++ b/exp/expression-parser.l
@@ -0,0 +1,167 @@
+%{
+
+/*
+ * (C) Copyright 2014, Stephen M. Cameron.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#include <stdio.h>
+#include <string.h>
+#include "y.tab.h"
+
+#define YYSTYPE PARSER_VALUE_TYPE
+
+extern int lexer_input(char* buffer, int *nbytes, int buffersize);
+
+#undef YY_INPUT
+#define YY_INPUT(buffer, bytes_read, bytes_requested) \
+		lexer_input((buffer), &(bytes_read), (bytes_requested))
+
+extern int yyerror(long long *result, double *dresult,
+		int *has_error, int *units_specified, const char *msg);
+
+static void __attribute__((unused)) yyunput(int c,char *buf_ptr);
+static int __attribute__((unused)) input(void);
+
+#define set_suffix_value(yylval, i_val, d_val, has_d_val) \
+	(yylval).v.dval = (d_val); \
+	(yylval).v.ival = (i_val); \
+	(yylval).v.has_dval = (has_d_val); \
+	(yylval).v.has_error = 0;
+
+%}
+
+%%
+
+
+[kK]|[kK][bB] 	{
+			set_suffix_value(yylval, 1024, 1024.0, 0);
+			return SUFFIX;
+		}
+[Mm]|[Mm][bB]	{
+			set_suffix_value(yylval, 1024 * 1024, 1024.0 * 1024.0, 0);
+			return SUFFIX;
+		}
+[mM][sS]	{
+			set_suffix_value(yylval, 1000, 1000.0, 1);
+			return SUFFIX;
+		}
+[uU][sS]	{
+			set_suffix_value(yylval, 1, 1.0, 1);
+			return SUFFIX;
+		}
+[gG]|[Gg][Bb]	{
+			set_suffix_value(yylval, 1024LL * 1024 * 1024, 1024.0 * 1024.0 * 1024, 0);
+			return SUFFIX;
+		}
+[tT]|[tT][bB]	{	
+			set_suffix_value(yylval, 1024LL * 1024 * 1024 * 1024,
+						1024.0 * 1024.0 * 1024.0 * 1024.0 * 1024, 0);
+			return SUFFIX;
+		}
+[pP]|[pP][bB]	{	
+			set_suffix_value(yylval, 1024LL * 1024 * 1024 * 1024 * 1024,
+					1024.0 * 1024.0 * 1024.0 * 1024.0 * 1024.0, 0);
+			return SUFFIX;
+		}
+[kK][iI][Bb]	{
+			set_suffix_value(yylval, 1000LL, 1000.0, 0);
+			return SUFFIX;
+		}
+[mM][Ii][bB]	{
+			set_suffix_value(yylval, 1000000LL, 1000000.0 , 0);
+			return SUFFIX;
+		}
+[gG][iI][Bb]	{
+			set_suffix_value(yylval, 1000000000LL, 1000000000.0 , 0);
+			return SUFFIX;
+		}
+[pP][iI][Bb]	{	
+			set_suffix_value(yylval, 1000000000000LL, 1000000000000.0 , 0);
+			return SUFFIX;
+		}
+[sS]		{
+			set_suffix_value(yylval, 1000000LL, 1000000.0 , 0);
+			return SUFFIX;
+		}
+[dD]		{
+			set_suffix_value(yylval, 60LL * 60LL * 24LL * 1000000LL,
+						60.0 * 60.0 * 24.0 * 1000000.0, 0);
+			return SUFFIX;
+		}
+[hH]		{	
+			set_suffix_value(yylval, 60LL * 60LL * 1000000LL,
+					60.0 * 60.0 * 1000000.0, 0);
+			return SUFFIX;
+		}
+[ \t] ; /* ignore whitespace */
+[#:,].* ; /* ignore comments, and everything after colons and commas */
+[0-9]*[.][0-9]+|[0-9]*[.]?[0-9]+[eE][-+]*[0-9]+ {
+			int rc;
+			double dval;
+
+			rc = sscanf(yytext, "%lf", &dval);
+			if (rc == 1) {
+				yylval.v.dval = dval;
+				yylval.v.ival = (long long) dval;
+				yylval.v.has_dval = 1;
+				yylval.v.has_error = 0;
+				return NUMBER;
+			} else {
+				yyerror(0, 0, 0, 0, "bad number\n");
+				yylval.v.has_error = 1;
+				return NUMBER;
+			}
+		}
+0x[0-9a-fA-F]+ {
+		int rc, intval;
+		rc = sscanf(yytext, "%x", &intval);
+		if (rc == 1) {
+			yylval.v.ival = intval;
+			yylval.v.dval = (double) intval;
+			yylval.v.has_dval = 0;
+			yylval.v.has_error = 0;
+			return NUMBER;
+		} else {
+			yyerror(0, 0, 0, 0, "bad number\n");
+			yylval.v.has_error = 1;
+			return NUMBER;
+		}
+	}
+[0-9]+	{
+		int rc, intval;
+		rc = sscanf(yytext, "%d", &intval);
+		if (rc == 1) {
+			yylval.v.ival = intval;
+			yylval.v.dval = (double) intval;
+			yylval.v.has_dval = 0;
+			yylval.v.has_error = 0;
+			return NUMBER;
+		} else {
+			yyerror(0, 0, 0, 0, "bad number\n");
+			yylval.v.has_error = 1;
+			return NUMBER;
+		}
+	}
+\n	return 0;
+[+-/*()^%]	return yytext[0];
+
+.	{
+		yylval.v.has_error = 1;
+		return NUMBER;	
+	}
+%%
+
diff --git a/exp/expression-parser.y b/exp/expression-parser.y
new file mode 100644
index 0000000..e4373d4
--- /dev/null
+++ b/exp/expression-parser.y
@@ -0,0 +1,244 @@
+%{
+
+/*
+ * (C) Copyright 2014, Stephen M. Cameron.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#include <stdio.h>
+#include <string.h>
+#include <math.h>
+struct parser_value_type {
+	double dval;
+	long long ival;
+	int has_dval;
+	int has_error;
+};
+
+typedef union valtype {
+	struct parser_value_type v;
+} PARSER_VALUE_TYPE;
+
+#define YYSTYPE PARSER_VALUE_TYPE
+
+int yyerror(__attribute__((unused)) long long *result,
+		__attribute__((unused)) double *dresult,
+		__attribute__((unused)) int *has_error,
+		__attribute__((unused)) int *units_specified,
+		__attribute__((unused)) const char *msg);
+
+extern int yylex(void);
+extern void yyrestart(FILE *file);
+
+%}
+
+%union valtype {
+	struct parser_value_type {
+		double dval;
+		long long ival;
+		int has_dval;
+		int has_error;
+	} v;
+};
+
+%token <v> NUMBER
+%token <v> BYE
+%token <v> SUFFIX 
+%left '-' '+'
+%right SUFFIX
+%left '*' '/'
+%right '^'
+%left '%'
+%nonassoc UMINUS
+%parse-param { long long *result }
+%parse-param { double *dresult }
+%parse-param { int *has_error }
+%parse-param { int *units_specified }
+
+%type <v> expression
+%%
+
+top_level:	expression {
+				*result = $1.ival;
+				*dresult = $1.dval;
+				*has_error = $1.has_error;
+			}
+		| expression error {
+				*result = $1.ival;
+				*dresult = $1.dval;
+				*has_error = 1;
+			}
+expression:	expression '+' expression { 
+			if (!$1.has_dval && !$3.has_dval)
+				$$.ival = $1.ival + $3.ival;
+			else
+				$$.ival = (long long) ($1.dval + $3.dval);
+			$$.dval = $1.dval + $3.dval;
+			$$.has_error = $1.has_error || $3.has_error;
+		}
+	|	expression '-' expression {
+			if (!$1.has_dval && !$3.has_dval)
+				$$.ival = $1.ival - $3.ival; 
+			else
+				$$.ival = (long long) ($1.dval - $3.dval); 
+			$$.dval = $1.dval - $3.dval; 
+			$$.has_error = $1.has_error || $3.has_error;
+		}
+	|	expression '*' expression {
+			if (!$1.has_dval && !$3.has_dval)
+				$$.ival = $1.ival * $3.ival;
+			else
+				$$.ival = (long long) ($1.dval * $3.dval);
+			$$.dval = $1.dval * $3.dval;
+			$$.has_error = $1.has_error || $3.has_error;
+		}
+	|	expression '/' expression {
+			if ($3.ival == 0)
+				yyerror(0, 0, 0, 0, "divide by zero");
+			else
+				$$.ival = $1.ival / $3.ival;
+			if ($3.dval < 1e-20 && $3.dval > -1e-20)
+				yyerror(0, 0, 0, 0, "divide by zero");
+			else
+				$$.dval = $1.dval / $3.dval;
+			if ($3.has_dval || $1.has_dval)
+				$$.ival = (long long) $$.dval;
+			$$.has_error = $1.has_error || $3.has_error;
+		}
+	|	'-' expression %prec UMINUS {
+			$$.ival = -$2.ival;
+			$$.dval = -$2.dval;
+			$$.has_error = $2.has_error;
+		}
+	|	'(' expression ')' { $$ = $2; }
+	|	expression SUFFIX {
+			if (!$1.has_dval && !$2.has_dval)
+				$$.ival = $1.ival * $2.ival;
+			else
+				$$.ival = (long long) $1.dval * $2.dval;
+			if ($1.has_dval || $2.has_dval)
+				$$.dval = $1.dval * $2.dval;
+			else
+				$$.dval = $1.ival * $2.ival;
+			$$.has_error = $1.has_error || $2.has_error;
+			*units_specified = 1;
+		}
+	|	expression '%' expression {
+			if ($1.has_dval || $3.has_dval)
+				yyerror(0, 0, 0, 0, "modulo on floats");
+			if ($3.ival == 0)
+				yyerror(0, 0, 0, 0, "divide by zero");
+			else {
+				$$.ival = $1.ival % $3.ival;
+				$$.dval = $$.ival;
+			}
+			$$.has_error = $1.has_error || $3.has_error;
+		}
+	|	expression '^' expression {
+			$$.has_error = $1.has_error || $3.has_error;
+			if (!$1.has_dval && !$3.has_dval) {
+				int i;
+
+				if ($3.ival == 0) {
+					$$.ival = 1;
+				} else if ($3.ival > 0) {
+					long long tmp = $1.ival;
+					$$.ival = 1.0;
+					for (i = 0; i < $3.ival; i++)
+						$$.ival *= tmp;
+				}  else {
+					/* integers, 2^-3, ok, we now have doubles */
+					double tmp;
+					if ($1.ival == 0 && $3.ival == 0) {
+						tmp = 1.0;
+						$$.has_error = 1;
+					} else {
+						double x = (double) $1.ival;
+						double y = (double) $3.ival;
+						tmp = pow(x, y);
+					}
+					$$.ival = (long long) tmp;
+				}
+				$$.dval = pow($1.dval, $3.dval);
+			} else {
+				$$.dval = pow($1.dval, $3.dval);
+				$$.ival = (long long) $$.dval;
+			}
+		}
+	|	NUMBER { $$ = $1; };
+%%
+#include <stdio.h>
+
+/* Urgh.  yacc and lex are kind of horrible.  This is not thread safe, obviously. */
+static int lexer_read_offset = 0;
+static char lexer_input_buffer[1000];
+
+int lexer_input(char* buffer, int *bytes_read, int bytes_requested)
+{
+	int bytes_left = strlen(lexer_input_buffer) - lexer_read_offset;
+
+	if (bytes_requested > bytes_left )
+		bytes_requested = bytes_left;
+	memcpy(buffer, &lexer_input_buffer[lexer_read_offset], bytes_requested);
+	*bytes_read = bytes_requested;
+	lexer_read_offset += bytes_requested;
+	return 0;
+}
+
+static void setup_to_parse_string(const char *string)
+{
+	unsigned int len;
+
+	len = strlen(string);
+	if (len > sizeof(lexer_input_buffer) - 3)
+		len = sizeof(lexer_input_buffer) - 3;
+
+	strncpy(lexer_input_buffer, string, len);
+	lexer_input_buffer[len] = '\0'; 
+	lexer_input_buffer[len + 1] = '\0';  /* lex/yacc want string double null terminated! */
+	lexer_read_offset = 0;
+}
+
+int evaluate_arithmetic_expression(const char *buffer, long long *ival, double *dval,
+					double implied_units)
+{
+	int rc, units_specified = 0, has_error = 0;
+
+	setup_to_parse_string(buffer);
+	rc = yyparse(ival, dval, &has_error, &units_specified);
+	yyrestart(NULL);
+	if (rc || has_error) {
+		*ival = 0;
+		*dval = 0;
+		has_error = 1;
+	}
+	if (!units_specified) {
+		*ival = (int) ((double) *ival * implied_units);
+		*dval = *dval * implied_units;
+	}
+	return has_error;
+}
+
+int yyerror(__attribute__((unused)) long long *result,
+		__attribute__((unused)) double *dresult,
+		__attribute__((unused)) int *has_error,
+		__attribute__((unused)) int *units_specified,
+		__attribute__((unused)) const char *msg)
+{
+	/* We do not need to do anything here. */
+	return 0;
+}
+
diff --git a/exp/test-expression-parser.c b/exp/test-expression-parser.c
new file mode 100644
index 0000000..93c766a
--- /dev/null
+++ b/exp/test-expression-parser.c
@@ -0,0 +1,54 @@
+/*
+ * (C) Copyright 2014, Stephen M. Cameron.
+ *
+ * The license below covers all files distributed with fio unless otherwise
+ * noted in the file itself.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License version 2 as
+ *  published by the Free Software Foundation.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+ *
+ */
+
+#include <stdio.h>
+#include <string.h>
+
+#include "../y.tab.h"
+
+extern int evaluate_arithmetic_expression(const char *buffer, long long *ival,
+					  double *dval, double implied_units);
+ 
+int main(int argc, char *argv[])
+{
+	int rc, bye = 0;
+	long long result;
+	double dresult;
+	char buffer[100];
+
+	do {
+		if (fgets(buffer, 90, stdin) == NULL)
+			break;
+		rc = strlen(buffer);
+		if (rc > 0 && buffer[rc - 1] == '\n')
+			buffer[rc - 1] = '\0';
+		rc = evaluate_arithmetic_expression(buffer, &result, &dresult, 1.0);
+		if (!rc) {
+			printf("%lld (%20.20lf)\n", result, dresult);
+		} else {
+			fprintf(stderr, "Syntax error\n");
+			result = 0;
+			dresult = 0;
+		}
+	} while (!bye);
+	return 0;
+}
+
diff --git a/fio.1 b/fio.1
index d64fbb7..b4dec91 100644
--- a/fio.1
+++ b/fio.1
@@ -115,7 +115,29 @@ and there may be any number of global sections.  Specific job definitions
 may override any parameter set in global sections.
 .SH "JOB PARAMETERS"
 .SS Types
-Some parameters may take arguments of a specific type.  The types used are:
+Some parameters may take arguments of a specific type.
+Anywhere a numeric value is required, an arithmetic expression may be used,
+provided it is surrounded by parentheses. Supported operators are:
+.RS
+.RS
+.TP
+.B addition (+)
+.TP
+.B subtraction (-)
+.TP
+.B multiplication (*)
+.TP
+.B division (/)
+.TP
+.B modulus (%)
+.TP
+.B exponentiation (^)
+.RE
+.RE
+.P
+For time values in expressions, units are microseconds by default. This is
+different than for time values not in expressions (not enclosed in
+parentheses). The types used are:
 .TP
 .I str
 String: a sequence of alphanumeric characters.
diff --git a/os/windows/install.wxs b/os/windows/install.wxs
index 18918cc..7338d63 100755
--- a/os/windows/install.wxs
+++ b/os/windows/install.wxs
@@ -10,7 +10,7 @@
 	<Product Id="*"
 	  Codepage="1252" Language="1033"
 	  Manufacturer="fio" Name="fio"
-	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.1.12">
+	  UpgradeCode="2338A332-5511-43CF-B9BD-5C60496CCFCC" Version="2.1.13">
 		<Package
 		  Description="Flexible IO Tester"
 		  InstallerVersion="301" Keywords="Installer,MSI,Database"
diff --git a/parse.c b/parse.c
index 40cd465..9e31908 100644
--- a/parse.c
+++ b/parse.c
@@ -18,6 +18,10 @@
 #include "minmax.h"
 #include "lib/ieee754.h"
 
+#ifdef CONFIG_ARITHMETIC
+#include "y.tab.h"
+#endif
+
 static struct fio_option *__fio_options;
 
 static int vp_cmp(const void *p1, const void *p2)
@@ -264,12 +268,76 @@ static unsigned long long get_mult_bytes(const char *str, int len, void *data,
 	return __get_mult_bytes(p, data, percent);
 }
 
+extern int evaluate_arithmetic_expression(const char *buffer, long long *ival,
+					  double *dval, double implied_units);
+
+#ifdef CONFIG_ARITHMETIC
+/*
+ * These two verification functions are just to gain confidence that
+ * the arithmetic processing code is always getting the same answer as the
+ * original number parsing code.  Once sufficiently sure that the arithmetic
+ * code is always getting the right answers, these can be removed.
+ */
+static void verify_exp_parser_float(const char *str, double implied_units)
+{
+	long long ival;
+	double dval, tmpval;
+
+	if (sscanf(str, "%lf", &tmpval) != 1)
+		return;
+
+	if (evaluate_arithmetic_expression(str, &ival, &dval, implied_units) != 0) {
+		log_info("Arithmetic failed on '%s'\n", str);
+		return;
+	}
+	if (dval != tmpval) {
+		log_info("Arithmetic failed on: '%s' got %lf, expected %lf\n",
+				str, dval, tmpval);
+	}
+}
+
+static void verify_exp_parser_decimal(const char *str, long long val, int kilo, int is_seconds)
+{
+	int rc;
+	long long ival;
+	double dval;
+	double implied_units = 1.0;
+
+	if (is_seconds)
+		implied_units = 1000000.0;
+
+	rc = evaluate_arithmetic_expression(str, &ival, &dval, implied_units);
+	if (!rc) {
+		if (ival != val)
+			log_info("Arithmetic failed on '%s', expected %lld, got %lld\n",
+				str, val, ival);
+	} else {
+		log_info("Arithmetic failed on '%s'\n", str);
+	}
+}
+#endif
+
 /*
  * Convert string into a floating number. Return 1 for success and 0 otherwise.
  */
 int str_to_float(const char *str, double *val)
 {
-	return (1 == sscanf(str, "%lf", val));
+#ifdef CONFIG_ARITHMETIC
+	int rc;
+	long long ival;
+	double dval;
+
+	if (str[0] == '(') {
+		rc = evaluate_arithmetic_expression(str, &ival, &dval, 1.0);
+		if (!rc) {
+			*val = dval;
+			return 1;
+		}
+	} else {
+		verify_exp_parser_float(str, 1.0);
+	}
+#endif
+	return 1 == sscanf(str, "%lf", val);
 }
 
 /*
@@ -279,19 +347,40 @@ int str_to_decimal(const char *str, long long *val, int kilo, void *data,
 		   int is_seconds)
 {
 	int len, base;
+	int rc = 1;
+#ifdef CONFIG_ARITHMETIC
+	long long ival;
+	double dval;
+	double implied_units = 1.0;
+#endif
 
 	len = strlen(str);
 	if (!len)
 		return 1;
 
-	if (strstr(str, "0x") || strstr(str, "0X"))
-		base = 16;
-	else
-		base = 10;
+#ifdef CONFIG_ARITHMETIC
+	if (is_seconds)
+		implied_units = 1000000.0;
+	if (str[0] == '(')
+		rc = evaluate_arithmetic_expression(str, &ival, &dval, implied_units);
+	if (str[0] == '(' && !rc) {
+		if (!kilo && is_seconds)
+			*val = ival / 1000000LL;
+		else
+			*val = ival;
+	}
+#endif
 
-	*val = strtoll(str, NULL, base);
-	if (*val == LONG_MAX && errno == ERANGE)
-		return 1;
+	if (rc == 1) {
+		if (strstr(str, "0x") || strstr(str, "0X"))
+			base = 16;
+		else
+			base = 10;
+
+		*val = strtoll(str, NULL, base);
+		if (*val == LONG_MAX && errno == ERANGE)
+			return 1;
+	}
 
 	if (kilo) {
 		unsigned long long mult;
@@ -304,7 +393,9 @@ int str_to_decimal(const char *str, long long *val, int kilo, void *data,
 			*val *= mult;
 	} else
 		*val *= get_mult_time(str, len, is_seconds);
-
+#ifdef CONFIG_ARITHMETIC
+	verify_exp_parser_decimal(str, *val, kilo, is_seconds);
+#endif
 	return 0;
 }
 
