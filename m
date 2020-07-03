Return-Path: <ykorman@gmail.com>
Return-Path: <ykorman@gmail.com>
From: Yigal Korman <ykorman@gmail.com>
Subject: [PATCH v2 4/4] fio: better info when engine not found
Date: Fri,  3 Jul 2020 15:38:43 +0300
Message-Id: <2d4f9a4795760950d3581e2569452b06adebba00.1593761533.git.ykorman@gmail.com>
In-Reply-To: <cover.1593761533.git.ykorman@gmail.com>
References: <cover.1593761533.git.ykorman@gmail.com>
In-Reply-To: <cover.1593761533.git.ykorman@gmail.com>
References: <cover.1593761533.git.ykorman@gmail.com>
To: axboe@kernel.dk
Cc: Yigal Korman <ykorman@gmail.com>, fio@vger.kernel.org
List-ID: <fio@vger.kernel.org>

Jans suggested we provide the user with the likely reasons why we failed
to load the given engine.
This should help better resolve these issues.

Signed-off-by: Yigal Korman <ykorman@gmail.com>
---
 ioengines.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/ioengines.c b/ioengines.c
index 78262bc1..c1b430a1 100644
--- a/ioengines.c
+++ b/ioengines.c
@@ -79,10 +79,16 @@ static struct ioengine_ops *find_ioengine(const char *name)
 static void *dlopen_external(struct thread_data *td, const char *engine)
 {
 	char engine_path[PATH_MAX];
+	void *dlhandle;
 
 	sprintf(engine_path, "%s/lib%s.so", FIO_EXT_ENG_DIR, engine);
 
-	return dlopen(engine_path, RTLD_LAZY);
+	dlhandle = dlopen(engine_path, RTLD_LAZY);
+	if (!dlhandle)
+		log_info("Engine %s not found; Either name is invalid, was not built, or fio-engine-%s package is missing.\n",
+			 engine, engine);
+
+	return dlhandle;
 }
 #else
 #define dlopen_external(td, engine) (NULL)
-- 
2.17.1


