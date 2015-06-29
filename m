Return-Path: <haghdoost@gmail.com>
MIME-Version: 1.0
In-Reply-To: <55918558.8090006@kernel.dk>
References: <CAB-428=biE+PMVOA8qg_VcH9bf0ZVZO1dimXVh3KC3Z7j=QrmQ@mail.gmail.com>
 <5591687D.6040803@kernel.dk> <CAB-428=EKjcxK6J9OvKU1nM34Q998fN=LFQKgNgofeMb_cuY1g@mail.gmail.com>
 <55916A66.5080303@kernel.dk> <55916C87.1030408@kernel.dk> <CAB-428=ToOGYb=5r6VhORWiFqXoHk6N8tMX8HbUr2_Cctf9oWw@mail.gmail.com>
 <55918558.8090006@kernel.dk>
From: Alireza Haghdoost <haghdoost@gmail.com>
Date: Mon, 29 Jun 2015 13:25:29 -0500
Message-ID: <CAB-428=30M7HXTfL4P3KpyjAG3dqMA9vVirc8iyjbO-8eAgDrQ@mail.gmail.com>
Subject: Re: competime_assert failure without -O3 optimization flag expected ?
Content-Type: text/plain; charset=UTF-8
To: Jens Axboe <axboe@kernel.dk>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>
List-ID: <fio@vger.kernel.org>

On Mon, Jun 29, 2015 at 12:50 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 06/29/2015 11:42 AM, Alireza Haghdoost wrote:
>>
>> Jens,
>>
>> Sounds like the compiletime_assert() method was not function and is
>> relying on the optimizer performing dead code elimination to remove
>> the call to prefix ## suffix
>>
>> How about this solution: I guess we have to work around it to make it
>> more portable since it works with C11.
>>
>> diff --git a/fio-arh/compiler/compiler.h b/fio-arh/compiler/compiler.h
>> index 40e857c..7c9ba57 100644
>> --- a/fio-arh/compiler/compiler.h
>> +++ b/fio-arh/compiler/compiler.h
>> @@ -33,26 +33,6 @@
>>    1; \
>>   })
>>
>> -#ifndef __compiletime_error
>> -#define __compiletime_error(message)
>> -#endif
>> -#ifndef __compiletime_error_fallback
>> -#define __compiletime_error_fallback(condition) do { } while (0)
>> -#endif
>> -
>> -#define __compiletime_assert(condition, msg, prefix, suffix) \
>> - do { \
>> - int __cond = !(condition); \
>> - extern void prefix ## suffix(void) __compiletime_error(msg); \
>> - if (__cond) \
>> - prefix ## suffix(); \
>> - __compiletime_error_fallback(__cond); \
>> - } while (0)
>> -
>> -#define _compiletime_assert(condition, msg, prefix, suffix) \
>> - __compiletime_assert(condition, msg, prefix, suffix)
>> -
>> -#define compiletime_assert(condition, msg) \
>> - _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)
>> +#define compiletime_assert(condition, msg) _Static_assert(condition, msg)
>>
>>   #endif
>
>
> But now it's more compiler dependent, which is worse than before. At least
> it only broke if people fiddled with the optimizations before, otherwise it
> was fine.
>
> Add a configure test for this, use _Static_assert() if it's available, the
> old method if not.

Here you are:

diff --git a/fio-arh/compiler/compiler.h b/fio-arh/compiler/compiler.h
index 40e857c..93fdc56 100644
--- a/fio-arh/compiler/compiler.h
+++ b/fio-arh/compiler/compiler.h
@@ -1,5 +1,6 @@
 #ifndef FIO_COMPILER_H
 #define FIO_COMPILER_H
+#include <assert.h>

 #if __GNUC__ >= 4
 #include "compiler-gcc4.h"
@@ -33,6 +34,12 @@
  1; \
 })

+
+#if (__STDC_VERSION__ >= 201112L)
+#define compiletime_assert(condition, msg) _Static_assert(condition, msg)
+#else
+
+
 #ifndef __compiletime_error
 #define __compiletime_error(message)
 #endif
@@ -55,4 +62,7 @@
 #define compiletime_assert(condition, msg) \
  _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)

+
+#endif
+
 #endif

