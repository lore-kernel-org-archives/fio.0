Return-Path: <fio-owner@vger.kernel.org>
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728633AbgDUMAU (ORCPT
        <rfc822;fio@vger.kernel.org>); Tue, 21 Apr 2020 08:00:20 -0400
Received: from merlin.infradead.org (unknown [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 224AAC061A0F
        for <fio@vger.kernel.org>; Tue, 21 Apr 2020 05:00:20 -0700 (PDT)
Received: from [65.144.74.35] (helo=kernel.dk)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jQrZL-0005z8-AB
        for fio@vger.kernel.org; Tue, 21 Apr 2020 12:00:03 +0000
Subject: Recent changes (master)
From: Jens Axboe <axboe@kernel.dk>
Message-Id: <20200421120001.80FB81BC019C@kernel.dk>
Date: Tue, 21 Apr 2020 06:00:01 -0600 (MDT)
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

The following changes since commit c65057f93d1de62a48f98578e24716128ce77a75:

  zbd: Fix I/O direction adjustment step for random read/write (2020-04-17 08:32:15 -0600)

are available in the Git repository at:

  git://git.kernel.dk/fio.git master

for you to fetch changes up to 173ff874d01466fa19f41998225d173cafd7e3bc:

  json: don't use named initializers for anonymous unions (2020-04-20 21:20:03 -0600)

----------------------------------------------------------------
Jens Axboe (1):
      json: don't use named initializers for anonymous unions

 json.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

---

Diff of recent changes:

diff --git a/json.h b/json.h
index 09c2f187..b2bb457e 100644
--- a/json.h
+++ b/json.h
@@ -57,9 +57,9 @@ static inline int json_object_add_value_int(struct json_object *obj,
 {
 	struct json_value arg = {
 		.type = JSON_TYPE_INTEGER,
-		.integer_number = val,
 	};
 
+	arg.integer_number = val;
 	return json_object_add_value_type(obj, name, &arg);
 }
 
@@ -68,9 +68,9 @@ static inline int json_object_add_value_float(struct json_object *obj,
 {
 	struct json_value arg = {
 		.type = JSON_TYPE_FLOAT,
-		.float_number = val,
 	};
 
+	arg.float_number = val;
 	return json_object_add_value_type(obj, name, &arg);
 }
 
@@ -80,9 +80,9 @@ static inline int json_object_add_value_string(struct json_object *obj,
 {
 	struct json_value arg = {
 		.type = JSON_TYPE_STRING,
-		.string = (char *)val,
 	};
 
+	arg.string = (char *)val;
 	return json_object_add_value_type(obj, name, &arg);
 }
 
@@ -104,9 +104,9 @@ static inline int json_object_add_value_array(struct json_object *obj,
 {
 	struct json_value arg = {
 		.type = JSON_TYPE_ARRAY,
-		.array = val,
 	};
 
+	arg.array = val;
 	return json_object_add_value_type(obj, name, &arg);
 }
 
@@ -118,9 +118,9 @@ static inline int json_array_add_value_int(struct json_array *obj,
 {
 	struct json_value arg = {
 		.type = JSON_TYPE_INTEGER,
-		.integer_number = val,
 	};
 
+	arg.integer_number = val;
 	return json_array_add_value_type(obj, &arg);
 }
 
@@ -129,9 +129,9 @@ static inline int json_array_add_value_float(struct json_array *obj,
 {
 	struct json_value arg = {
 		.type = JSON_TYPE_FLOAT,
-		.float_number = val,
 	};
 
+	arg.float_number = val;
 	return json_array_add_value_type(obj, &arg);
 }
 
@@ -140,9 +140,9 @@ static inline int json_array_add_value_string(struct json_array *obj,
 {
 	struct json_value arg = {
 		.type = JSON_TYPE_STRING,
-		.string = (char *)val,
 	};
 
+	arg.string = (char *)val;
 	return json_array_add_value_type(obj, &arg);
 }
 
@@ -151,9 +151,9 @@ static inline int json_array_add_value_object(struct json_array *obj,
 {
 	struct json_value arg = {
 		.type = JSON_TYPE_OBJECT,
-		.object = val,
 	};
 
+	arg.object = val;
 	return json_array_add_value_type(obj, &arg);
 }
 
@@ -162,9 +162,9 @@ static inline int json_array_add_value_array(struct json_array *obj,
 {
 	struct json_value arg = {
 		.type = JSON_TYPE_ARRAY,
-		.array = val,
 	};
 
+	arg.array = val;
 	return json_array_add_value_type(obj, &arg);
 }
 

