Return-Path: <fio-owner@vger.kernel.org>
Received: from tone.orchestra.cse.unsw.EDU.AU ([129.94.242.59]:49984 "EHLO
	tone.orchestra.cse.unsw.EDU.AU" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751378AbYJDGbk (ORCPT
	<rfc822;fio@vger.kernel.org>); Sat, 4 Oct 2008 02:31:40 -0400
Received: From
	[192.168.2.14] ([121.209.209.212] == CPE-121-209-209-212.nsw.bigpond.net.au) (auth-user aaronc) (cse-authentic-sender aaronc)
	(for <fio@vger.kernel.org>) By tone With Smtp ;
	Sat, 4 Oct 2008 16:31:09 +1000 
From: Aaron Carroll <aaronc@gelato.unsw.edu.au>
Date: Sat, 04 Oct 2008 16:31:09 +1000
Message-ID: <48E70DAD.5000604@gelato.unsw.edu.au>
MIME-Version: 1.0
Subject: [PATCH] Add environment-variable substitution to config options
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I have a nasty bash script that performs environment variable substitution for running
automated benchmarks.  This seems like a reasonable feature for FIO... so here it is.

The code is quite perilous, and hasn't been particularly well tested.

Thanks,
   -- Aaron


---

Strings of the form ${VARNAME} in config option strings are substituted with
the value of the environment variable VARNAME.  Only the right hand side of
an option assignment undergoes substitution.  If VARNAME is empty or
undefined, the empty string is substituted.

Signed-off-by: Aaron Carroll <aaronc@gelato.unsw.edu.au>
---
 parse.c |   52 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 parse.h |    1 +
 2 files changed, 52 insertions(+), 1 deletions(-)

diff --git a/parse.c b/parse.c
index b946690..456e3ba 100644
--- a/parse.c
+++ b/parse.c
@@ -8,6 +8,7 @@
 #include <string.h>
 #include <errno.h>
 #include <limits.h>
+#include <stdlib.h>
 
 #include "parse.h"
 #include "debug.h"
@@ -529,12 +530,61 @@ int parse_cmd_option(const char *opt, const char *val,
 	return 1;
 }
 
+/*
+ * Return a copy of the input string with substrings of the form ${VARNAME}
+ * substituted with the value of the environment variable VARNAME.  The
+ * substitution always occurs, even if VARNAME is empty or the corresponding
+ * environment variable undefined.
+ */
+static char *option_dup_subs(const char *opt)
+{
+	char out[OPT_LEN_MAX+1];
+	char in[OPT_LEN_MAX+1];
+	char *outptr = out;
+	char *inptr = in;
+	char *ch1, *ch2, *env;
+	ssize_t nchr = OPT_LEN_MAX;
+	size_t envlen;
+
+	in[OPT_LEN_MAX] = '\0';
+	strncpy(in, opt, OPT_LEN_MAX);
+
+	while (*inptr && nchr > 0) {
+		if (inptr[0] == '$' && inptr[1] == '{') {
+			ch2 = strchr(inptr, '}');
+			if (ch2 && inptr+1 < ch2) {
+				ch1 = inptr+2;
+				inptr = ch2+1;
+				*ch2 = '\0';
+
+				env = getenv(ch1);
+				if (env) {
+					envlen = strlen(env);
+					if (envlen <= nchr) {
+						memcpy(outptr, env, envlen);
+						outptr += envlen;
+						nchr -= envlen;
+					}
+				}
+
+				continue;
+			}
+		}
+
+		*outptr++ = *inptr++;
+		--nchr;
+	}
+
+	*outptr = '\0';
+	return strdup(out);
+}
+
 int parse_option(const char *opt, struct fio_option *options, void *data)
 {
 	struct fio_option *o;
 	char *post, *tmp;
 
-	tmp = strdup(opt);
+	tmp = option_dup_subs(opt);
 
 	o = get_option(tmp, options, &post);
 	if (!o) {
diff --git a/parse.h b/parse.h
index 4f3f94d..4546259 100644
--- a/parse.h
+++ b/parse.h
@@ -26,6 +26,7 @@ struct value_pair {
 	const char *help;		/* help text for sub option */
 };
 
+#define OPT_LEN_MAX 	1024
 #define PARSE_MAX_VP	16
 
 /*
