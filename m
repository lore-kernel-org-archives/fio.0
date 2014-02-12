Return-Path: <axboe@kernel.dk>
Date: Tue, 11 Feb 2014 21:49:38 -0700
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: New build warnings on Windows
Message-ID: <20140212044938.GA11527@kernel.dk>
References: <52FAB6D5.5070903@cran.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52FAB6D5.5070903@cran.org.uk>
To: Bruce Cran <bruce@cran.org.uk>, "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On 2014-02-11 16:48, Bruce Cran wrote:
> There are some new warnings in 2.1.5 when building on Windows:
>
> In file included from io_u.c:14:0:
> err.h: In function ‘ERR_PTR’:
> err.h:18:9: warning: cast to pointer from integer of different size
> [-Wint-to-pointer-cast]
> return (void *) error;
> ^
> err.h: In function ‘PTR_ERR’:
> err.h:23:9: warning: cast from pointer to integer of different size
> [-Wpointer-to-int-cast]
> return (long) ptr;
> ^
> err.h: In function ‘IS_ERR’:
> err.h:28:22: warning: cast from pointer to integer of different size
> [-Wpointer-to-int-cast]
> return IS_ERR_VALUE((unsigned long)ptr);
> ^
> err.h:14:27: note: in definition of macro ‘IS_ERR_VALUE’
> #define IS_ERR_VALUE(x) ((x) >= (unsigned long)-MAX_ERRNO)
> ^
> err.h: In function ‘IS_ERR_OR_NULL’:
> err.h:33:30: warning: cast from pointer to integer of different size
> [-Wpointer-to-int-cast]
> return !ptr || IS_ERR_VALUE((unsigned long)ptr);
> ^
> err.h:14:27: note: in definition of macro ‘IS_ERR_VALUE’
> #define IS_ERR_VALUE(x) ((x) >= (unsigned long)-MAX_ERRNO)

Gah, I should have caught that. Looks like I'll be spinning a 2.1.5.1 or 
2.1.6 shortly too. Does the below fix it up?

diff --git a/err.h b/err.h
index 5c024ee88786..fef5c545bf3c 100644
--- a/err.h
+++ b/err.h
@@ -11,26 +11,26 @@
  */
 #define MAX_ERRNO	4095
 
-#define IS_ERR_VALUE(x) ((x) >= (unsigned long)-MAX_ERRNO)
+#define IS_ERR_VALUE(x) ((x) >= (uintptr_t)-MAX_ERRNO)
 
 static inline void *ERR_PTR(long error)
 {
 	return (void *) error;
 }
 
-static inline long PTR_ERR(const void *ptr)
+static inline uintptr_t PTR_ERR(const void *ptr)
 {
-	return (long) ptr;
+	return (uintptr_t) ptr;
 }
 
-static inline long IS_ERR(const void *ptr)
+static inline uintptr_t IS_ERR(const void *ptr)
 {
-	return IS_ERR_VALUE((unsigned long)ptr);
+	return IS_ERR_VALUE((uintptr_t) ptr);
 }
 
-static inline long IS_ERR_OR_NULL(const void *ptr)
+static inline uintptr_t IS_ERR_OR_NULL(const void *ptr)
 {
-	return !ptr || IS_ERR_VALUE((unsigned long)ptr);
+	return !ptr || IS_ERR_VALUE((uintptr_t)ptr);
 }
 
 static inline int PTR_ERR_OR_ZERO(const void *ptr)

-- 
Jens Axboe

