Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.cran.org.uk ([93.89.92.64]:43984 "EHLO muon.cran.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895AbaDCSUA (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 3 Apr 2014 14:20:00 -0400
Received: from muon.cran.org.uk (localhost [127.0.0.1])
	by muon.cran.org.uk (Postfix) with ESMTP id 75A83E7489
	for <fio@vger.kernel.org>; Thu,  3 Apr 2014 19:19:58 +0100 (BST)
Received: from [10.0.10.15] (c-67-177-56-43.hsd1.ut.comcast.net [67.177.56.43])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by muon.cran.org.uk (Postfix) with ESMTPSA id B0225E73AD
	for <fio@vger.kernel.org>; Thu,  3 Apr 2014 19:19:56 +0100 (BST)
Message-ID: <533DA646.9070807@cran.org.uk>
Date: Thu, 03 Apr 2014 12:19:50 -0600
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: io_bytes overflow in JSON output on Windows
Content-Type: multipart/mixed;
 boundary="------------070500060500050802050309"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

This is a multi-part message in MIME format.
--------------070500060500050802050309
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On Windows, the io_bytes parameter can overflow in the JSON output 
because the JSON_INTEGER type is a 'long' - which is only 32-bit on 
Windows.  The attached patch should fix it by changing the JSON integer 
type to be 'long long'.

-- 
Bruce Cran



--------------070500060500050802050309
Content-Type: text/plain; charset=windows-1252;
 name="0001-Fix-JSON_INTEGER-overflow-on-Windows-by-changing-dat.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Fix-JSON_INTEGER-overflow-on-Windows-by-changing-dat.pa";
 filename*1="tch"

From 819255df8c084d9d05e5fcb67ba2620e581cd3e0 Mon Sep 17 00:00:00 2001
From: Bruce Cran <bcran@fusionio.com>
Date: Thu, 3 Apr 2014 12:17:00 -0600
Subject: [PATCH] Fix JSON_INTEGER overflow on Windows by changing datatype to
 'long long'

---
 json.c | 8 ++++----
 json.h | 2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

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
-- 
1.9.0.msysgit.0


--------------070500060500050802050309--
