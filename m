Return-Path: <fio-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:44707 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbaKKNAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 11 Nov 2014 08:00:05 -0500
Received: from kernel.dk ([54.225.238.116] helo=lyth.info)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1XoB3E-0007eJ-DR
	for fio@vger.kernel.org; Tue, 11 Nov 2014 13:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20141111130003.75540401DC@lyth.info>
Date: Tue, 11 Nov 2014 06:00:03 -0700 (MST)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit e5437a073e658e8154b9e87bab5c7b3b06ed4255:

  Fix for a race when fio prints I/O statistics periodically (2014-11-09 20:24:14 -0700)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 88038bc7193e648cef39061e0b8d6ef8203a1e63:

  Fixup some of the time (usec) based conversions (2014-11-10 20:31:26 -0700)

----------------------------------------------------------------
Jens Axboe (4):
      t/btrace2fio: cap depth if we don't see completion traces
      Add option for statically build fio
      Fix crash on threads being reaped before they are created
      Get rid if ddir_trim() macro

Stephen M. Cameron (1):
      Fixup some of the time (usec) based conversions

 backend.c                    |    6 ++++--
 configure                    |   14 ++++++++++++++
 eta.c                        |    3 +--
 exp/expression-parser.l      |   13 ++++++++++++-
 exp/expression-parser.y      |    4 +++-
 exp/test-expression-parser.c |    4 ++--
 init.c                       |    8 ++++----
 io_ddir.h                    |    2 --
 io_u.c                       |    4 ++--
 ioengines.c                  |    2 +-
 options.c                    |   14 +++++++++++---
 parse.c                      |   35 ++++++++++++++++++++---------------
 parse.h                      |    5 +++--
 t/btrace2fio.c               |   24 ++++++++++++++++++++++--
 14 files changed, 99 insertions(+), 39 deletions(-)

---

Diff of recent changes:

diff --git a/backend.c b/backend.c
index 59a14d1..a93c458 100644
--- a/backend.c
+++ b/backend.c
@@ -2105,8 +2105,10 @@ int fio_backend(void)
 
 	for_each_td(td, i) {
 		fio_options_free(td);
-		fio_mutex_remove(td->rusage_sem);
-		td->rusage_sem = NULL;
+		if (td->rusage_sem) {
+			fio_mutex_remove(td->rusage_sem);
+			td->rusage_sem = NULL;
+		}
 	}
 
 	free_disk_util();
diff --git a/configure b/configure
index eefe28e..aaad70e 100755
--- a/configure
+++ b/configure
@@ -152,6 +152,8 @@ for opt do
   ;;
   --build-32bit-win) build_32bit_win="yes"
   ;;
+  --build-static) build_static="yes"
+  ;;
   --enable-gfio)
   gfio_check="yes"
   ;;
@@ -178,6 +180,7 @@ if test "$show_help" = "yes" ; then
   echo "--cc=                  Specify compiler to use"
   echo "--extra-cflags=        Specify extra CFLAGS to pass to compiler"
   echo "--build-32bit-win      Enable 32-bit build on Windows"
+  echo "--build-static         Build a static fio"
   echo "--esx                  Configure build options for esx"
   echo "--enable-gfio          Enable building of gtk gfio"
   echo "--disable-numa         Disable libnuma even if found"
@@ -400,6 +403,16 @@ echo "Cross compile                 $cross_compile"
 echo
 
 ##########################################
+# See if we need to build a static build
+if test "$build_static" = "yes" ; then
+  CFLAGS="$CFLAGS -ffunction-sections -fdata-sections"
+  LDFLAGS="$LDFLAGS -static -Wl,--gc-sections"
+else
+  build_static="no"
+fi
+echo "Static build                  $build_static"
+
+##########################################
 # check for wordsize
 wordsize="0"
 cat > $TMPC <<EOF
@@ -1566,5 +1579,6 @@ fi
 
 echo "LIBS+=$LIBS" >> $config_host_mak
 echo "CFLAGS+=$CFLAGS" >> $config_host_mak
+echo "LDFLAGS+=$LDFLAGS" >> $config_host_mak
 echo "CC=$cc" >> $config_host_mak
 echo "BUILD_CFLAGS=$BUILD_CFLAGS $CFLAGS" >> $config_host_mak
diff --git a/eta.c b/eta.c
index db08e2a..5be5aed 100644
--- a/eta.c
+++ b/eta.c
@@ -555,8 +555,7 @@ void display_thread_status(struct jobs_eta *je)
 	if (!eta_new_line_init) {
 		fio_gettime(&disp_eta_new_line, NULL);
 		eta_new_line_init = 1;
-	} else if (eta_new_line &&
-		   mtime_since_now(&disp_eta_new_line) > eta_new_line * 1000) {
+	} else if (eta_new_line && mtime_since_now(&disp_eta_new_line) > eta_new_line) {
 		fio_gettime(&disp_eta_new_line, NULL);
 		eta_new_line_pending = 1;
 	}
diff --git a/exp/expression-parser.l b/exp/expression-parser.l
index 856596a..50bd383 100644
--- a/exp/expression-parser.l
+++ b/exp/expression-parser.l
@@ -42,6 +42,9 @@ extern int yyerror(long long *result, double *dresult,
 static void __attribute__((unused)) yyunput(int c, char *buf_ptr);
 static int __attribute__((unused)) input(void);
 
+/* set by parser -- this is another thing which makes the parser thread-unsafe :(. */
+int lexer_value_is_time = 0; /* for determining if "m" suffix means mega- or minutes */
+
 #define set_suffix_value(yylval, i_val, d_val, has_d_val) \
 	(yylval).v.dval = (d_val); \
 	(yylval).v.ival = (i_val); \
@@ -57,7 +60,7 @@ static int __attribute__((unused)) input(void);
 			set_suffix_value(yylval, 1024, 1024.0, 0);
 			return SUFFIX;
 		}
-[Mm]|[Mm][bB]	{
+[Mm][bB]	{
 			set_suffix_value(yylval, 1024 * 1024, 1024.0 * 1024.0, 0);
 			return SUFFIX;
 		}
@@ -103,6 +106,14 @@ static int __attribute__((unused)) input(void);
 			set_suffix_value(yylval, 1000000LL, 1000000.0 , 0);
 			return SUFFIX;
 		}
+[mM]		{
+			if (!lexer_value_is_time) {
+				set_suffix_value(yylval, 1024 * 1024, 1024.0 * 1024.0, 0);
+			} else {
+				set_suffix_value(yylval, 60LL * 1000000LL, 60.0 * 1000000.0, 0);
+			}
+			return SUFFIX;
+		}
 [dD]		{
 			set_suffix_value(yylval, 60LL * 60LL * 24LL * 1000000LL,
 						60.0 * 60.0 * 24.0 * 1000000.0, 0);
diff --git a/exp/expression-parser.y b/exp/expression-parser.y
index 8ae0c01..d664b8e 100644
--- a/exp/expression-parser.y
+++ b/exp/expression-parser.y
@@ -43,6 +43,7 @@ int yyerror(__attribute__((unused)) long long *result,
 
 extern int yylex(void);
 extern void yyrestart(FILE *file);
+extern int lexer_value_is_time;
 
 %}
 
@@ -214,10 +215,11 @@ static void setup_to_parse_string(const char *string)
 }
 
 int evaluate_arithmetic_expression(const char *buffer, long long *ival, double *dval,
-					double implied_units)
+					double implied_units, int is_time)
 {
 	int rc, units_specified = 0, has_error = 0;
 
+	lexer_value_is_time = is_time;
 	setup_to_parse_string(buffer);
 	rc = yyparse(ival, dval, &has_error, &units_specified);
 	yyrestart(NULL);
diff --git a/exp/test-expression-parser.c b/exp/test-expression-parser.c
index 93c766a..bf3fb3e 100644
--- a/exp/test-expression-parser.c
+++ b/exp/test-expression-parser.c
@@ -25,7 +25,7 @@
 #include "../y.tab.h"
 
 extern int evaluate_arithmetic_expression(const char *buffer, long long *ival,
-					  double *dval, double implied_units);
+					  double *dval, double implied_units, int is_time);
  
 int main(int argc, char *argv[])
 {
@@ -40,7 +40,7 @@ int main(int argc, char *argv[])
 		rc = strlen(buffer);
 		if (rc > 0 && buffer[rc - 1] == '\n')
 			buffer[rc - 1] = '\0';
-		rc = evaluate_arithmetic_expression(buffer, &result, &dresult, 1.0);
+		rc = evaluate_arithmetic_expression(buffer, &result, &dresult, 1.0, 0);
 		if (!rc) {
 			printf("%lld (%20.20lf)\n", result, dresult);
 		} else {
diff --git a/init.c b/init.c
index c2c126b..70d5d06 100644
--- a/init.c
+++ b/init.c
@@ -1968,12 +1968,12 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 		case 'E': {
 			long long t = 0;
 
-			if (str_to_decimal(optarg, &t, 0, NULL, 1)) {
+			if (check_str_time(optarg, &t, 1)) {
 				log_err("fio: failed parsing eta time %s\n", optarg);
 				exit_val = 1;
 				do_exit++;
 			}
-			eta_new_line = t;
+			eta_new_line = t / 1000;
 			break;
 			}
 		case 'd':
@@ -2175,13 +2175,13 @@ int parse_cmd_line(int argc, char *argv[], int client_type)
 		case 'L': {
 			long long val;
 
-			if (check_str_time(optarg, &val, 0)) {
+			if (check_str_time(optarg, &val, 1)) {
 				log_err("fio: failed parsing time %s\n", optarg);
 				do_exit++;
 				exit_val = 1;
 				break;
 			}
-			status_interval = val * 1000;
+			status_interval = val / 1000;
 			break;
 			}
 		case '?':
diff --git a/io_ddir.h b/io_ddir.h
index a23ea62..795cecc 100644
--- a/io_ddir.h
+++ b/io_ddir.h
@@ -64,8 +64,6 @@ static inline const char *ddir_str(enum td_ddir ddir)
 	return ddir_str[ddir];
 }
 
-#define ddir_trim(ddir) ((ddir) == DDIR_TRIM)
-
 #define ddir_rw_sum(arr)	\
 	((arr)[DDIR_READ] + (arr)[DDIR_WRITE] + (arr)[DDIR_TRIM])
 
diff --git a/io_u.c b/io_u.c
index 438ad5d..e8894d5 100644
--- a/io_u.c
+++ b/io_u.c
@@ -580,8 +580,8 @@ static enum fio_ddir rate_ddir(struct thread_data *td, enum fio_ddir ddir)
 	if (td_rw(td) && __should_check_rate(td, odir))
 		td->rate_pending_usleep[odir] -= usec;
 
-	if (ddir_trim(ddir))
-		return ddir;
+	if (ddir == DDIR_TRIM)
+		return DDIR_TRIM;
 
 	return ddir;
 }
diff --git a/ioengines.c b/ioengines.c
index 07d1d56..6370a56 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -321,7 +321,7 @@ int td_io_queue(struct thread_data *td, struct io_u *io_u)
 			 "support direct IO, or iomem_align= is bad.\n");
 	}
 
-	if (!td->io_ops->commit || ddir_trim(io_u->ddir)) {
+	if (!td->io_ops->commit || io_u->ddir == DDIR_TRIM) {
 		io_u_mark_submit(td, 1);
 		io_u_mark_complete(td, 1);
 	}
diff --git a/options.c b/options.c
index 529b8f0..ac09480 100644
--- a/options.c
+++ b/options.c
@@ -102,7 +102,7 @@ static int bssplit_ddir(struct thread_options *o, int ddir, char *str)
 		} else
 			perc = -1U;
 
-		if (str_to_decimal(fname, &val, 1, o, 0)) {
+		if (str_to_decimal(fname, &val, 1, o, 0, 0)) {
 			log_err("fio: bssplit conversion failed\n");
 			free(bssplit);
 			return 1;
@@ -342,7 +342,7 @@ static int str_rw_cb(void *data, const char *str)
 	else {
 		long long val;
 
-		if (str_to_decimal(nr, &val, 1, o, 0)) {
+		if (str_to_decimal(nr, &val, 1, o, 0, 0)) {
 			log_err("fio: rw postfix parsing failed\n");
 			free(nr);
 			return 1;
@@ -738,7 +738,7 @@ static int str_random_distribution_cb(void *data, const char *str)
 		return 0;
 
 	nr = get_opt_postfix(str);
-	if (nr && !str_to_float(nr, &val)) {
+	if (nr && !str_to_float(nr, &val, 0)) {
 		log_err("fio: random postfix parsing failed\n");
 		free(nr);
 		return 1;
@@ -2177,6 +2177,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.help	= "Only start job when this period has passed",
 		.def	= "0",
 		.is_seconds = 1,
+		.is_time = 1,
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_RUNTIME,
 	},
@@ -2189,6 +2190,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.help	= "Stop workload when this amount of time has passed",
 		.def	= "0",
 		.is_seconds = 1,
+		.is_time = 1,
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_RUNTIME,
 	},
@@ -2217,6 +2219,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.off1	= td_var_offset(ramp_time),
 		.help	= "Ramp up time before measuring performance",
 		.is_seconds = 1,
+		.is_time = 1,
 		.category = FIO_OPT_C_GENERAL,
 		.group	= FIO_OPT_G_RUNTIME,
 	},
@@ -2770,6 +2773,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.off1	= td_var_offset(thinktime),
 		.help	= "Idle time between IO buffers (usec)",
 		.def	= "0",
+		.is_time = 1,
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_THINKTIME,
 	},
@@ -2780,6 +2784,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.off1	= td_var_offset(thinktime_spin),
 		.help	= "Start think time by spinning this amount (usec)",
 		.def	= "0",
+		.is_time = 1,
 		.parent	= "thinktime",
 		.hide	= 1,
 		.category = FIO_OPT_C_IO,
@@ -2863,6 +2868,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.type	= FIO_OPT_INT,
 		.off1	= td_var_offset(max_latency),
 		.help	= "Maximum tolerated IO latency (usec)",
+		.is_time = 1,
 		.category = FIO_OPT_C_IO,
 		.group = FIO_OPT_G_LATPROF,
 	},
@@ -2872,6 +2878,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.type	= FIO_OPT_STR_VAL_TIME,
 		.off1	= td_var_offset(latency_target),
 		.help	= "Ramp to max queue depth supporting this latency",
+		.is_time = 1,
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_LATPROF,
 	},
@@ -2881,6 +2888,7 @@ struct fio_option fio_options[FIO_MAX_OPTS] = {
 		.type	= FIO_OPT_STR_VAL_TIME,
 		.off1	= td_var_offset(latency_window),
 		.help	= "Time to sustain latency_target",
+		.is_time = 1,
 		.category = FIO_OPT_C_IO,
 		.group	= FIO_OPT_G_LATPROF,
 	},
diff --git a/parse.c b/parse.c
index 282baa4..4209647 100644
--- a/parse.c
+++ b/parse.c
@@ -269,7 +269,8 @@ static unsigned long long get_mult_bytes(const char *str, int len, void *data,
 }
 
 extern int evaluate_arithmetic_expression(const char *buffer, long long *ival,
-					  double *dval, double implied_units);
+					  double *dval, double implied_units,
+					  int is_time);
 
 #ifdef CONFIG_ARITHMETIC
 /*
@@ -278,7 +279,7 @@ extern int evaluate_arithmetic_expression(const char *buffer, long long *ival,
  * original number parsing code.  Once sufficiently sure that the arithmetic
  * code is always getting the right answers, these can be removed.
  */
-static void verify_exp_parser_float(const char *str, double implied_units)
+static void verify_exp_parser_float(const char *str, double implied_units, int is_time)
 {
 	long long ival;
 	double dval, tmpval;
@@ -286,7 +287,7 @@ static void verify_exp_parser_float(const char *str, double implied_units)
 	if (sscanf(str, "%lf", &tmpval) != 1)
 		return;
 
-	if (evaluate_arithmetic_expression(str, &ival, &dval, implied_units) != 0) {
+	if (evaluate_arithmetic_expression(str, &ival, &dval, implied_units, is_time) != 0) {
 		log_info("Arithmetic failed on '%s'\n", str);
 		return;
 	}
@@ -296,7 +297,8 @@ static void verify_exp_parser_float(const char *str, double implied_units)
 	}
 }
 
-static void verify_exp_parser_decimal(const char *str, long long val, int kilo, int is_seconds)
+static void verify_exp_parser_decimal(const char *str, long long val, int kilo, int is_seconds,
+				      int is_time)
 {
 	int rc;
 	long long ival;
@@ -306,7 +308,7 @@ static void verify_exp_parser_decimal(const char *str, long long val, int kilo,
 	if (is_seconds)
 		implied_units = 1000000.0;
 
-	rc = evaluate_arithmetic_expression(str, &ival, &dval, implied_units);
+	rc = evaluate_arithmetic_expression(str, &ival, &dval, implied_units, is_time);
 	if (!rc) {
 		if (ival != val)
 			log_info("Arithmetic failed on '%s', expected %lld, got %lld\n",
@@ -320,7 +322,7 @@ static void verify_exp_parser_decimal(const char *str, long long val, int kilo,
 /*
  * Convert string into a floating number. Return 1 for success and 0 otherwise.
  */
-int str_to_float(const char *str, double *val)
+int str_to_float(const char *str, double *val, int is_time)
 {
 #ifdef CONFIG_ARITHMETIC
 	int rc;
@@ -328,13 +330,13 @@ int str_to_float(const char *str, double *val)
 	double dval;
 
 	if (str[0] == '(') {
-		rc = evaluate_arithmetic_expression(str, &ival, &dval, 1.0);
+		rc = evaluate_arithmetic_expression(str, &ival, &dval, 1.0, is_time);
 		if (!rc) {
 			*val = dval;
 			return 1;
 		}
 	} else {
-		verify_exp_parser_float(str, 1.0);
+		verify_exp_parser_float(str, 1.0, is_time);
 	}
 #endif
 	return 1 == sscanf(str, "%lf", val);
@@ -344,7 +346,7 @@ int str_to_float(const char *str, double *val)
  * convert string into decimal value, noting any size suffix
  */
 int str_to_decimal(const char *str, long long *val, int kilo, void *data,
-		   int is_seconds)
+		   int is_seconds, int is_time)
 {
 	int len, base;
 	int rc = 1;
@@ -362,7 +364,7 @@ int str_to_decimal(const char *str, long long *val, int kilo, void *data,
 	if (is_seconds)
 		implied_units = 1000000.0;
 	if (str[0] == '(')
-		rc = evaluate_arithmetic_expression(str, &ival, &dval, implied_units);
+		rc = evaluate_arithmetic_expression(str, &ival, &dval, implied_units, is_time);
 	if (str[0] == '(' && !rc) {
 		if (!kilo && is_seconds)
 			*val = ival / 1000000LL;
@@ -394,19 +396,19 @@ int str_to_decimal(const char *str, long long *val, int kilo, void *data,
 	} else
 		*val *= get_mult_time(str, len, is_seconds);
 #ifdef CONFIG_ARITHMETIC
-	verify_exp_parser_decimal(str, *val, kilo, is_seconds);
+	verify_exp_parser_decimal(str, *val, kilo, is_seconds, is_time);
 #endif
 	return 0;
 }
 
 int check_str_bytes(const char *p, long long *val, void *data)
 {
-	return str_to_decimal(p, val, 1, data, 0);
+	return str_to_decimal(p, val, 1, data, 0, 0);
 }
 
 int check_str_time(const char *p, long long *val, int is_seconds)
 {
-	return str_to_decimal(p, val, 0, NULL, is_seconds);
+	return str_to_decimal(p, val, 0, NULL, is_seconds, 1);
 }
 
 void strip_blank_front(char **p)
@@ -448,7 +450,7 @@ static int check_range_bytes(const char *str, long *val, void *data)
 {
 	long long __val;
 
-	if (!str_to_decimal(str, &__val, 1, data, 0)) {
+	if (!str_to_decimal(str, &__val, 1, data, 0, 0)) {
 		*val = __val;
 		return 0;
 	}
@@ -552,6 +554,9 @@ static int __handle_option(struct fio_option *o, const char *ptr, void *data,
 		fio_opt_str_val_fn *fn = o->cb;
 		char tmp[128], *p;
 
+		if (!is_time && o->is_time)
+			is_time = o->is_time;
+
 		strncpy(tmp, ptr, sizeof(tmp) - 1);
 		p = strchr(tmp, ',');
 		if (p)
@@ -655,7 +660,7 @@ static int __handle_option(struct fio_option *o, const char *ptr, void *data,
 					o->maxlen);
 			return 1;
 		}
-		if (!str_to_float(ptr, &uf)) {
+		if (!str_to_float(ptr, &uf, 0)) { /* this breaks if we ever have lists of times */
 			log_err("not a floating point value: %s\n", ptr);
 			return 1;
 		}
diff --git a/parse.h b/parse.h
index 2a1e06a..a9d726d 100644
--- a/parse.h
+++ b/parse.h
@@ -73,6 +73,7 @@ struct fio_option {
 	unsigned int group;		/* who to group with */
 	void *gui_data;
 	int is_seconds;			/* time value with seconds base */
+	int is_time;			/* time based value */
 	int no_warn_def;
 };
 
@@ -89,10 +90,10 @@ extern void options_free(struct fio_option *, void *);
 
 extern void strip_blank_front(char **);
 extern void strip_blank_end(char *);
-extern int str_to_decimal(const char *, long long *, int, void *, int);
+extern int str_to_decimal(const char *, long long *, int, void *, int, int);
 extern int check_str_bytes(const char *p, long long *val, void *data);
 extern int check_str_time(const char *p, long long *val, int);
-extern int str_to_float(const char *str, double *val);
+extern int str_to_float(const char *str, double *val, int is_time);
 
 /*
  * Handlers for the options
diff --git a/t/btrace2fio.c b/t/btrace2fio.c
index 32dda92..bf67ed0 100644
--- a/t/btrace2fio.c
+++ b/t/btrace2fio.c
@@ -19,6 +19,7 @@ static unsigned int rt_threshold = 1000000;
 static unsigned int ios_threshold = 10;
 static unsigned int rate_threshold;
 static unsigned int set_rate;
+static unsigned int max_depth = 256;
 static int output_ascii = 1;
 static char *filename;
 
@@ -45,6 +46,9 @@ struct btrace_out {
 
 	int inflight;
 	unsigned int depth;
+	int depth_disabled;
+	int complete_seen;
+
 	uint64_t first_ttime[DDIR_RWDIR_CNT];
 	uint64_t last_ttime[DDIR_RWDIR_CNT];
 	uint64_t kb[DDIR_RWDIR_CNT];
@@ -125,7 +129,13 @@ static void inflight_add(struct btrace_pid *p, uint64_t sector, uint32_t len)
 	i = calloc(1, sizeof(*i));
 	i->p = p;
 	o->inflight++;
-	o->depth = max((int) o->depth, o->inflight);
+	if (!o->depth_disabled) {
+		o->depth = max((int) o->depth, o->inflight);
+		if (o->depth >= max_depth && !o->complete_seen) {
+			o->depth_disabled = 1;
+			o->depth = max_depth;
+		}
+	}
 	i->end_sector = sector + (len >> 9);
 	__inflight_add(i);
 }
@@ -383,6 +393,7 @@ static int handle_trace(struct blk_io_trace *t, struct btrace_pid *p)
 		i = inflight_find(t->sector + (t->bytes >> 9));
 		if (i) {
 			i->p->o.kb[t_to_rwdir(t)] += (t->bytes >> 10);
+			i->p->o.complete_seen = 1;
 			inflight_remove(i);
 		}
 	}
@@ -810,6 +821,7 @@ static int output_p(void)
 {
 	unsigned long ios[DDIR_RWDIR_CNT];
 	struct flist_head *e, *tmp;
+	int depth_disabled = 0;
 	int ret = 0;
 
 	flist_for_each_safe(e, tmp, &pid_list) {
@@ -821,8 +833,12 @@ static int output_p(void)
 			continue;
 		}
 		p->o.start_delay = (o_first_ttime(&p->o) / 1000ULL) - first_ttime;
+		depth_disabled += p->o.depth_disabled;
 	}
 
+	if (depth_disabled)
+		log_err("fio: missing completion traces, depths capped at %u\n", max_depth);
+
 	memset(ios, 0, sizeof(ios));
 
 	flist_sort(NULL, &pid_list, entry_cmp);
@@ -851,6 +867,7 @@ static int usage(char *argv[])
 	log_err("\t-d\tUse this file/device for replay\n");
 	log_err("\t-r\tIgnore jobs with less than this KB/sec rate\n");
 	log_err("\t-R\tSet rate in fio job\n");
+	log_err("\t-D\tCap queue depth at this value (def=%u)\n", max_depth);
 	return 1;
 }
 
@@ -906,7 +923,7 @@ int main(int argc, char *argv[])
 	if (argc < 2)
 		return usage(argv);
 
-	while ((c = getopt(argc, argv, "t:n:fd:r:R")) != -1) {
+	while ((c = getopt(argc, argv, "t:n:fd:r:RD:")) != -1) {
 		switch (c) {
 		case 'R':
 			set_rate = 1;
@@ -926,6 +943,9 @@ int main(int argc, char *argv[])
 		case 'd':
 			filename = strdup(optarg);
 			break;
+		case 'D':
+			max_depth = atoi(optarg);
+			break;
 		case '?':
 		default:
 			return usage(argv);
