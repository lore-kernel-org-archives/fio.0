Return-Path: <fio-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:52556 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705AbaDDMAF (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 4 Apr 2014 08:00:05 -0400
Received: from kernel.dk ([54.225.238.116] helo=strynoevaenget.dk)
	by merlin.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WW2my-0007R8-L4
	for fio@vger.kernel.org; Fri, 04 Apr 2014 12:00:04 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20140404120003.1965F400AE@strynoevaenget.dk>
Date: Fri,  4 Apr 2014 06:00:02 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit 2e80228232afc9cf90ad06b360a33a05637978f3:

  Use setvbuf() for log writing (2014-04-02 21:47:27 -0600)

are available in the git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to ee2e5717d1df0c37279eb94876777ee43d403e58:

  Fix JSON_INTEGER overflow on Windows by changing datatype to 'long long' (2014-04-03 12:22:35 -0600)

----------------------------------------------------------------
Bruce Cran (1):
      Fix JSON_INTEGER overflow on Windows by changing datatype to 'long long'

Jens Axboe (1):
      parse: fix crash with empty FIO_OPT_STR_STORE variables

 json.c  |    8 ++++----
 json.h  |    2 +-
 parse.c |    3 +++
 3 files changed, 8 insertions(+), 5 deletions(-)

---

Diff of recent changes:

diff --git a/json.c b/json.c
index cba370a..7480a61 100644
--- a/json.c
+++ b/json.c
@@ -35,7 +35,7 @@ static struct json_pair *json_create_pair(const char *name, struct json_value *v
 	return pair;
 }
 
-static struct json_value *json_create_value_int(long number)
+static struct json_value *json_create_value_int(long long number)
 {
 	struct json_value *value = malloc(sizeof(struct json_value));
 
@@ -212,7 +212,7 @@ int json_object_add_value_type(struct json_object *obj, const char *name, int ty
 	if (type == JSON_TYPE_STRING)
 		value = json_create_value_string(va_arg(args, char *));
 	else if (type == JSON_TYPE_INTEGER)
-		value = json_create_value_int(va_arg(args, long));
+		value = json_create_value_int(va_arg(args, long long));
 	else if (type == JSON_TYPE_FLOAT)
 		value = json_create_value_float(va_arg(args, double));
 	else if (type == JSON_TYPE_OBJECT)
@@ -248,7 +248,7 @@ int json_array_add_value_type(struct json_array *array, int type, ...)
 	if (type == JSON_TYPE_STRING)
 		value = json_create_value_string(va_arg(args, char *));
 	else if (type == JSON_TYPE_INTEGER)
-		value = json_create_value_int(va_arg(args, long));
+		value = json_create_value_int(va_arg(args, long long));
 	else if (type == JSON_TYPE_FLOAT)
 		value = json_create_value_float(va_arg(args, double));
 	else if (type == JSON_TYPE_OBJECT)
@@ -350,7 +350,7 @@ static void json_print_value(struct json_value *value)
 		log_info("\"%s\"", value->string);
 		break;
 	case JSON_TYPE_INTEGER:
-		log_info("%ld", value->integer_number);
+		log_info("%lld", value->integer_number);
 		break;
 	case JSON_TYPE_FLOAT:
 		log_info("%.2f", value->float_number);
diff --git a/json.h b/json.h
index 2a798ce..081afd6 100644
--- a/json.h
+++ b/json.h
@@ -14,7 +14,7 @@ struct json_pair;
 struct json_value {
 	int type;
 	union {
-		long integer_number;
+		long long integer_number;
 		double float_number;
 		char *string;
 		struct json_object *object;
diff --git a/parse.c b/parse.c
index 079f19e..83c59f7 100644
--- a/parse.c
+++ b/parse.c
@@ -608,6 +608,9 @@ static int __handle_option(struct fio_option *o, const char *ptr, void *data,
 	case FIO_OPT_STR_STORE: {
 		fio_opt_str_fn *fn = o->cb;
 
+		if (!strlen(ptr))
+			return 1;
+
 		if (o->off1) {
 			cp = td_var(data, o, o->off1);
 			*cp = strdup(ptr);
