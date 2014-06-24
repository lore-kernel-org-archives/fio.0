Return-Path: <puthik@google.com>
Return-Path: <puthik@google.com>
From: Puthikorn Voravootivat <puthik@chromium.org>
Subject: [PATCH] Cast input argument for json_object_add_value_int to long long
Date: Tue, 24 Jun 2014 15:59:53 -0700
Message-Id: <1403650793-7086-1-git-send-email-puthik@chromium.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: FIO List <fio@vger.kernel.org>, Gwendal Grignou <gwendal@chromium.org>, Puthikorn Voravootivat <puthik@chromium.org>
List-ID: <fio@vger.kernel.org>

The latency related (and some other) variables type is uint32_t
but the JSON integer type is long long. So we need to cast
the numbers to long long type to make JSON output correctly.

Signed-off-by: Puthikorn Voravootivat <puthik@chromium.org>
---
Found this bug when test on arm. Fix may be a little hacky.
Feel free to change to better idea.
 json.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/json.h b/json.h
index 081afd6..962c11c 100644
--- a/json.h
+++ b/json.h
@@ -52,7 +52,7 @@ void json_free_object(struct json_object *obj);
 
 int json_object_add_value_type(struct json_object *obj, const char *name, int type, ...);
 #define json_object_add_value_int(obj, name, val) \
-	json_object_add_value_type((obj), name, JSON_TYPE_INTEGER, (val))
+	json_object_add_value_type((obj), name, JSON_TYPE_INTEGER, (long long) (val))
 #define json_object_add_value_float(obj, name, val) \
 	json_object_add_value_type((obj), name, JSON_TYPE_FLOAT, (val))
 #define json_object_add_value_string(obj, name, val) \
-- 
2.0.0.526.g5318336


