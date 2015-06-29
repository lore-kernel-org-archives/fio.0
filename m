Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([204.109.60.166]:43008 "EHLO
	muon.cran.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbbF2WkF (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 29 Jun 2015 18:40:05 -0400
Received: from muon.bluestop.org (localhost [127.0.0.1])
	by muon.cran.org.uk (Postfix) with ESMTP id ABD1E27334A
	for <fio@vger.kernel.org>; Mon, 29 Jun 2015 16:34:26 -0600 (MDT)
Received: from muon.cran.org.uk ([127.0.0.1])
	by muon.bluestop.org (muon.bluestop.org [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id Fx14V_SdNPvQ for <fio@vger.kernel.org>;
	Mon, 29 Jun 2015 16:34:25 -0600 (MDT)
Received: from [10.50.3.54] (63-158-132-10.dia.static.qwest.net [63.158.132.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by muon.cran.org.uk (Postfix) with ESMTPSA
	for <fio@vger.kernel.org>; Mon, 29 Jun 2015 16:34:25 -0600 (MDT)
Message-ID: <5591C7F0.1090004@cran.org.uk>
Date: Mon, 29 Jun 2015 16:34:24 -0600
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: FreeBSD build broken following _Static_assert commit
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

On FreeBSD 10.1 with clang 3.4.1, a standard "gmake" build now fails with:

libfio.c:309:21: error: static_assert expression is not an integral 
constant expression
         compiletime_assert((offsetof(struct thread_stat, 
percentile_list) % 8) == 0, "stat percentile_list");
~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
./compiler/compiler.h:39:59: note: expanded from macro 'compiletime_assert'
#define compiletime_assert(condition, msg) _Static_assert(condition, msg)
                                                           ^
libfio.c:309:22: note: cast that performs the conversions of a 
reinterpret_cast is not allowed in a constant expression
         compiletime_assert((offsetof(struct thread_stat, 
percentile_list) % 8) == 0, "stat percentile_list");
                             ^
./flist.h:10:33: note: expanded from macro 'offsetof'
#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
                                 ^
./compiler/compiler.h:39:59: note: expanded from macro 'compiletime_assert'
#define compiletime_assert(condition, msg) _Static_assert(condition, msg)
                                                           ^
libfio.c:310:21: error: static_assert expression is not an integral 
constant expression
         compiletime_assert((offsetof(struct thread_stat, 
total_run_time) % 8) == 0, "total_run_time");
~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
./compiler/compiler.h:39:59: note: expanded from macro 'compiletime_assert'
#define compiletime_assert(condition, msg) _Static_assert(condition, msg)
                                                           ^
libfio.c:310:22: note: cast that performs the conversions of a 
reinterpret_cast is not allowed in a constant expression
         compiletime_assert((offsetof(struct thread_stat, 
total_run_time) % 8) == 0, "total_run_time");
                             ^
./flist.h:10:33: note: expanded from macro 'offsetof'
#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
                                 ^
./compiler/compiler.h:39:59: note: expanded from macro 'compiletime_assert'
#define compiletime_assert(condition, msg) _Static_assert(condition, msg)
                                                           ^
libfio.c:311:21: error: static_assert expression is not an integral 
constant expression
         compiletime_assert((offsetof(struct thread_stat, 
total_err_count) % 8) == 0, "total_err_count");
~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
./compiler/compiler.h:39:59: note: expanded from macro 'compiletime_assert'
#define compiletime_assert(condition, msg) _Static_assert(condition, msg)
                                                           ^
libfio.c:311:22: note: cast that performs the conversions of a 
reinterpret_cast is not allowed in a constant expression
         compiletime_assert((offsetof(struct thread_stat, 
total_err_count) % 8) == 0, "total_err_count");
                             ^
./flist.h:10:33: note: expanded from macro 'offsetof'
#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
                                 ^
./compiler/compiler.h:39:59: note: expanded from macro 'compiletime_assert'
#define compiletime_assert(condition, msg) _Static_assert(condition, msg)
                                                           ^
libfio.c:312:21: error: static_assert expression is not an integral 
constant expression
         compiletime_assert((offsetof(struct thread_stat, 
latency_percentile) % 8) == 0, "stat latency_percentile");
~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
./compiler/compiler.h:39:59: note: expanded from macro 'compiletime_assert'
#define compiletime_assert(condition, msg) _Static_assert(condition, msg)
                                                           ^
libfio.c:312:22: note: cast that performs the conversions of a 
reinterpret_cast is not allowed in a constant expression
         compiletime_assert((offsetof(struct thread_stat, 
latency_percentile) % 8) == 0, "stat latency_percentile");
                             ^
./flist.h:10:33: note: expanded from macro 'offsetof'
#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
                                 ^
./compiler/compiler.h:39:59: note: expanded from macro 'compiletime_assert'
#define compiletime_assert(condition, msg) _Static_assert(condition, msg)
                                                           ^
libfio.c:313:21: error: static_assert expression is not an integral 
constant expression
         compiletime_assert((offsetof(struct thread_options_pack, 
zipf_theta) % 8) == 0, "zipf_theta");
~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
./compiler/compiler.h:39:59: note: expanded from macro 'compiletime_assert'
#define compiletime_assert(condition, msg) _Static_assert(condition, msg)
                                                           ^
libfio.c:313:22: note: cast that performs the conversions of a 
reinterpret_cast is not allowed in a constant expression
         compiletime_assert((offsetof(struct thread_options_pack, 
zipf_theta) % 8) == 0, "zipf_theta");
                             ^
./flist.h:10:33: note: expanded from macro 'offsetof'
#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
                                 ^
./compiler/compiler.h:39:59: note: expanded from macro 'compiletime_assert'
#define compiletime_assert(condition, msg) _Static_assert(condition, msg)
                                                           ^
libfio.c:314:21: error: static_assert expression is not an integral 
constant expression
         compiletime_assert((offsetof(struct thread_options_pack, 
pareto_h) % 8) == 0, "pareto_h");
~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
./compiler/compiler.h:39:59: note: expanded from macro 'compiletime_assert'
#define compiletime_assert(condition, msg) _Static_assert(condition, msg)
                                                           ^
libfio.c:314:22: note: cast that performs the conversions of a 
reinterpret_cast is not allowed in a constant expression
         compiletime_assert((offsetof(struct thread_options_pack, 
pareto_h) % 8) == 0, "pareto_h");
                             ^
./flist.h:10:33: note: expanded from macro 'offsetof'
#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
                                 ^
./compiler/compiler.h:39:59: note: expanded from macro 'compiletime_assert'
#define compiletime_assert(condition, msg) _Static_assert(condition, msg)
                                                           ^
libfio.c:315:21: error: static_assert expression is not an integral 
constant expression
         compiletime_assert((offsetof(struct thread_options_pack, 
percentile_list) % 8) == 0, "percentile_list");
~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
./compiler/compiler.h:39:59: note: expanded from macro 'compiletime_assert'
#define compiletime_assert(condition, msg) _Static_assert(condition, msg)
                                                           ^
libfio.c:315:22: note: cast that performs the conversions of a 
reinterpret_cast is not allowed in a constant expression
         compiletime_assert((offsetof(struct thread_options_pack, 
percentile_list) % 8) == 0, "percentile_list");
                             ^
./flist.h:10:33: note: expanded from macro 'offsetof'
#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
                                 ^
./compiler/compiler.h:39:59: note: expanded from macro 'compiletime_assert'
#define compiletime_assert(condition, msg) _Static_assert(condition, msg)
                                                           ^
libfio.c:316:21: error: static_assert expression is not an integral 
constant expression
         compiletime_assert((offsetof(struct thread_options_pack, 
latency_percentile) % 8) == 0, "latency_percentile");
~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
./compiler/compiler.h:39:59: note: expanded from macro 'compiletime_assert'
#define compiletime_assert(condition, msg) _Static_assert(condition, msg)
                                                           ^
libfio.c:316:22: note: cast that performs the conversions of a 
reinterpret_cast is not allowed in a constant expression
         compiletime_assert((offsetof(struct thread_options_pack, 
latency_percentile) % 8) == 0, "latency_percentile");
                             ^
./flist.h:10:33: note: expanded from macro 'offsetof'
#define offsetof(TYPE, MEMBER) ((size_t) &((TYPE *)0)->MEMBER)
                                 ^
./compiler/compiler.h:39:59: note: expanded from macro 'compiletime_assert'
#define compiletime_assert(condition, msg) _Static_assert(condition, msg)
                                                           ^
8 errors generated.

-- 
Bruce
