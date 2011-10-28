Return-Path: <tirea@google.com>
MIME-Version: 1.0
From: Steven Lang <tirea@google.com>
Date: Thu, 27 Oct 2011 18:17:10 -0600
Subject: [PATCH] Cleanup option keyword/environment substitution
Message-ID: 
 <CAAUT-yNorwr8cyuzpDuV9GW_n2yeuMvtTE_mgMkONMgSZLvZrg@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: Jens Axboe <JAxboe@fusionio.com>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Right now the substitution for options seems quite fragile.  Among the issu=
es...
- If bc had an error and returned no output, it caused a NULL reference
- Multiple variable substitutions (For example $ncpus * $pagesize)
caused an error as it tried to run bc after the first, with the second
still text
- Memory leak for every keyword substituted
- Multiplication caused shell wildcard expansion (*) of the current
directory when passing the input to bc
- Shell escape sequences would be parsed on the command line when bc is cal=
led
- Potential buffer overrun due to unchecked lengths on the input line

So I did a little cleanup to get rid of the issues.  This patch also
moves the environment variable substitution to run before the keyword
substitution, so an environment variable can now indirectly perform a
keyword substitution.

diff --git a/options.c b/options.c
index bb46dc9..84bf5ac 100644
--- a/options.c
+++ b/options.c
@@ -2218,15 +2218,15 @@ void fio_keywords_init(void)

 static char *bc_calc(char *str)
 {
-	char *buf, *tmp, opt[80];
+	char buf[128], *tmp;
 	FILE *f;
 	int ret;

 	/*
 	 * No math, just return string
 	 */
-	if (!strchr(str, '+') && !strchr(str, '-') && !strchr(str, '*') &&
-	    !strchr(str, '/'))
+	if ((!strchr(str, '+') && !strchr(str, '-') && !strchr(str, '*') &&
+	     !strchr(str, '/')) || strchr(str, '\''))
 		return str;

 	/*
@@ -2237,37 +2237,89 @@ static char *bc_calc(char *str)
 		return str;

 	tmp++;
-	memset(opt, 0, sizeof(opt));
-	strncpy(opt, str, tmp - str);

-	buf =3D malloc(128);
+	/*
+	 * Prevent buffer overflows; such a case isn't reasonable anyway
+	 */
+	if (strlen(str) >=3D 128 || strlen(tmp) > 100)
+		return str;

 	sprintf(buf, "which %s > /dev/null", BC_APP);
 	if (system(buf)) {
 		log_err("fio: bc is needed for performing math\n");
-		free(buf);
 		return NULL;
 	}

-	sprintf(buf, "echo %s | %s", tmp, BC_APP);
+	sprintf(buf, "echo '%s' | %s", tmp, BC_APP);
 	f =3D popen(buf, "r");
 	if (!f) {
-		free(buf);
 		return NULL;
 	}

-	ret =3D fread(buf, 1, 128, f);
+	ret =3D fread(&buf[tmp - str], 1, 128 - (tmp - str), f);
 	if (ret <=3D 0) {
-		free(buf);
 		return NULL;
 	}

-	buf[ret - 1] =3D '\0';
-	strcat(opt, buf);
-	strcpy(buf, opt);
 	pclose(f);
+	buf[(tmp - str) + ret - 1] =3D '\0';
+	memcpy(buf, str, tmp - str);
 	free(str);
-	return buf;
+	return strdup(buf);
+}
+
+/*
+ * Return a copy of the input string with substrings of the form ${VARNAME=
}
+ * substituted with the value of the environment variable VARNAME.  The
+ * substitution always occurs, even if VARNAME is empty or the correspondi=
ng
+ * environment variable undefined.
+ */
+static char *option_dup_subs(const char *opt)
+{
+	char out[OPT_LEN_MAX+1];
+	char in[OPT_LEN_MAX+1];
+	char *outptr =3D out;
+	char *inptr =3D in;
+	char *ch1, *ch2, *env;
+	ssize_t nchr =3D OPT_LEN_MAX;
+	size_t envlen;
+
+	if (strlen(opt) + 1 > OPT_LEN_MAX) {
+		log_err("OPT_LEN_MAX (%d) is too small\n", OPT_LEN_MAX);
+		return NULL;
+	}
+
+	in[OPT_LEN_MAX] =3D '\0';
+	strncpy(in, opt, OPT_LEN_MAX);
+
+	while (*inptr && nchr > 0) {
+		if (inptr[0] =3D=3D '$' && inptr[1] =3D=3D '{') {
+			ch2 =3D strchr(inptr, '}');
+			if (ch2 && inptr+1 < ch2) {
+				ch1 =3D inptr+2;
+				inptr =3D ch2+1;
+				*ch2 =3D '\0';
+
+				env =3D getenv(ch1);
+				if (env) {
+					envlen =3D strlen(env);
+					if (envlen <=3D nchr) {
+						memcpy(outptr, env, envlen);
+						outptr +=3D envlen;
+						nchr -=3D envlen;
+					}
+				}
+
+				continue;
+			}
+		}
+
+		*outptr++ =3D *inptr++;
+		--nchr;
+	}
+
+	*outptr =3D '\0';
+	return strdup(out);
 }

 /*
@@ -2277,6 +2329,7 @@ static char *fio_keyword_replace(char *opt)
 {
 	char *s;
 	int i;
+	int docalc =3D 0;

 	for (i =3D 0; fio_keywords[i].word !=3D NULL; i++) {
 		struct fio_keyword *kw =3D &fio_keywords[i];
@@ -2306,29 +2359,51 @@ static char *fio_keyword_replace(char *opt)
 			 * replace opt and free the old opt
 			 */
 			opt =3D new;
-			//free(o_org);
+			free(o_org);

-			/*
-			 * Check for potential math and invoke bc, if possible
-			 */
-			opt =3D bc_calc(opt);
+			docalc =3D 1;
 		}
 	}

+	/*
+	 * Check for potential math and invoke bc, if possible
+	 */
+	if (docalc)
+		opt =3D bc_calc(opt);
+
 	return opt;
 }

+static char **dup_and_sub_options(char **opts, int num_opts)
+{
+	int i;
+	char **opts_copy =3D malloc(num_opts * sizeof(*opts));
+	for (i =3D 0; i < num_opts; i++) {
+		opts_copy[i] =3D option_dup_subs(opts[i]);
+		if (!opts_copy[i])
+			continue;
+		opts_copy[i] =3D fio_keyword_replace(opts_copy[i]);
+	}
+	return opts_copy;
+}
+
 int fio_options_parse(struct thread_data *td, char **opts, int num_opts)
 {
 	int i, ret;
+	char **opts_copy;

 	sort_options(opts, options, num_opts);
+	opts_copy =3D dup_and_sub_options(opts, num_opts);

 	for (ret =3D 0, i =3D 0; i < num_opts; i++) {
-		opts[i] =3D fio_keyword_replace(opts[i]);
-		ret |=3D parse_option(opts[i], options, td);
+		ret |=3D parse_option(opts_copy[i], opts[i], options, td);
+
+		if (opts_copy[i])
+			free(opts_copy[i]);
+		opts_copy[i] =3D NULL;
 	}

+	free(opts_copy);
 	return ret;
 }

diff --git a/parse.c b/parse.c
index 18e8a40..7f7851c 100644
--- a/parse.c
+++ b/parse.c
@@ -199,9 +199,9 @@ static unsigned long long get_mult_bytes(const
char *str, int len, void *data,
 	if (len < 2)
 		return __get_mult_bytes(str, data, percent);

-        /*
-         * Go forward until we hit a non-digit, or +/- sign
-         */
+	/*
+	 * Go forward until we hit a non-digit, or +/- sign
+	 */
 	while ((p - str) <=3D len) {
 		if (!isdigit((int) *p) &&
 		    (((*p !=3D '+') && (*p !=3D '-')) || digit_seen))
@@ -798,83 +798,28 @@ int parse_cmd_option(const char *opt, const char *val=
,
 	return 1;
 }

-/*
- * Return a copy of the input string with substrings of the form ${VARNAME=
}
- * substituted with the value of the environment variable VARNAME.  The
- * substitution always occurs, even if VARNAME is empty or the correspondi=
ng
- * environment variable undefined.
- */
-static char *option_dup_subs(const char *opt)
-{
-	char out[OPT_LEN_MAX+1];
-	char in[OPT_LEN_MAX+1];
-	char *outptr =3D out;
-	char *inptr =3D in;
-	char *ch1, *ch2, *env;
-	ssize_t nchr =3D OPT_LEN_MAX;
-	size_t envlen;
-
-	if (strlen(opt) + 1 > OPT_LEN_MAX) {
-		log_err("OPT_LEN_MAX (%d) is too small\n", OPT_LEN_MAX);
-		return NULL;
-	}
-
-	in[OPT_LEN_MAX] =3D '\0';
-	strncpy(in, opt, OPT_LEN_MAX);
-
-	while (*inptr && nchr > 0) {
-		if (inptr[0] =3D=3D '$' && inptr[1] =3D=3D '{') {
-			ch2 =3D strchr(inptr, '}');
-			if (ch2 && inptr+1 < ch2) {
-				ch1 =3D inptr+2;
-				inptr =3D ch2+1;
-				*ch2 =3D '\0';
-
-				env =3D getenv(ch1);
-				if (env) {
-					envlen =3D strlen(env);
-					if (envlen <=3D nchr) {
-						memcpy(outptr, env, envlen);
-						outptr +=3D envlen;
-						nchr -=3D envlen;
-					}
-				}
-
-				continue;
-			}
-		}
-
-		*outptr++ =3D *inptr++;
-		--nchr;
-	}
-
-	*outptr =3D '\0';
-	return strdup(out);
-}
-
-int parse_option(const char *opt, struct fio_option *options, void *data)
+int parse_option(const char *opt, const char *input,
+		 struct fio_option *options, void *data)
 {
 	struct fio_option *o;
-	char *post, *tmp;
+	char *post;

-	tmp =3D option_dup_subs(opt);
-	if (!tmp)
+	if (!opt) {
+		log_err("fio: failed parsing %s\n", input);
 		return 1;
+	}

-	o =3D get_option(tmp, options, &post);
+	o =3D get_option(opt, options, &post);
 	if (!o) {
-		log_err("Bad option <%s>\n", tmp);
-		free(tmp);
+		log_err("Bad option <%s>\n", input);
 		return 1;
 	}

 	if (!handle_option(o, post, data)) {
-		free(tmp);
 		return 0;
 	}

-	log_err("fio: failed parsing %s\n", opt);
-	free(tmp);
+	log_err("fio: failed parsing %s\n", input);
 	return 1;
 }

diff --git a/parse.h b/parse.h
index cb0b48f..091923e 100644
--- a/parse.h
+++ b/parse.h
@@ -65,7 +65,7 @@ struct fio_option {

 typedef int (str_cb_fn)(void *, char *);

-extern int parse_option(const char *, struct fio_option *, void *);
+extern int parse_option(const char *, const char *, struct fio_option
*, void *);
 extern void sort_options(char **, struct fio_option *, int);
 extern int parse_cmd_option(const char *t, const char *l, struct
fio_option *, void *);
 extern int show_cmd_help(struct fio_option *, const char *);

