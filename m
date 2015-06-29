Return-Path: <haghdoost@gmail.com>
MIME-Version: 1.0
In-Reply-To: <55916C87.1030408@kernel.dk>
References: <CAB-428=biE+PMVOA8qg_VcH9bf0ZVZO1dimXVh3KC3Z7j=QrmQ@mail.gmail.com>
 <5591687D.6040803@kernel.dk> <CAB-428=EKjcxK6J9OvKU1nM34Q998fN=LFQKgNgofeMb_cuY1g@mail.gmail.com>
 <55916A66.5080303@kernel.dk> <55916C87.1030408@kernel.dk>
From: Alireza Haghdoost <haghdoost@gmail.com>
Date: Mon, 29 Jun 2015 12:42:51 -0500
Message-ID: <CAB-428=ToOGYb=5r6VhORWiFqXoHk6N8tMX8HbUr2_Cctf9oWw@mail.gmail.com>
Subject: Re: competime_assert failure without -O3 optimization flag expected ?
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

Jens,

Sounds like the compiletime_assert() method was not function and is
relying on the optimizer performing dead code elimination to remove
the call to prefix ## suffix

How about this solution: I guess we have to work around it to make it
more portable since it works with C11.

diff --git a/fio-arh/compiler/compiler.h b/fio-arh/compiler/compiler.h
index 40e857c..7c9ba57 100644
--- a/fio-arh/compiler/compiler.h
+++ b/fio-arh/compiler/compiler.h
@@ -33,26 +33,6 @@
  1; \
 })

-#ifndef __compiletime_error
-#define __compiletime_error(message)
-#endif
-#ifndef __compiletime_error_fallback
-#define __compiletime_error_fallback(condition) do { } while (0)
-#endif
-
-#define __compiletime_assert(condition, msg, prefix, suffix) \
- do { \
- int __cond = !(condition); \
- extern void prefix ## suffix(void) __compiletime_error(msg); \
- if (__cond) \
- prefix ## suffix(); \
- __compiletime_error_fallback(__cond); \
- } while (0)
-
-#define _compiletime_assert(condition, msg, prefix, suffix) \
- __compiletime_assert(condition, msg, prefix, suffix)
-
-#define compiletime_assert(condition, msg) \
- _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
+#define compiletime_assert(condition, msg) _Static_assert(condition, msg)

 #endif

On Mon, Jun 29, 2015 at 11:04 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 06/29/2015 09:55 AM, Jens Axboe wrote:
>>
>> On 06/29/2015 09:53 AM, Alireza Haghdoost wrote:
>>>
>>> Sure, I will investigate it. Just want to confirm the issue is in the
>>> compiletime_assert() code as you mentioned and it is not in that line
>>> of code that I cite in my last email. I managed to remedy this issue a
>>> little bit by using -O1 instead of -O3 but still the optimized program
>>> order is not exactly similar to the default source code order.
>>
>>
>> It bothers me too, I'll turn off optimizations for debugging things too,
>> and just end up uncommenting the lines to make that work. Apparently it
>> hasn't bothered me enough to fix it up yet, but I would love to see it
>> fixed.
>
>
> BTW, the issue is basically that without optimizations, gcc doesn't realize
> that the declared extern function doesn't get called. So asserts fail,
> doesn't matter if they are true or false.
>
> --
> Jens Axboe
>

