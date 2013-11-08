Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.cran.org.uk ([93.89.92.64]:46760 "EHLO muon.cran.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144Ab3KHNLa (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 8 Nov 2013 08:11:30 -0500
Received: from muon.cran.org.uk (localhost [127.0.0.1])
	by muon.cran.org.uk (Postfix) with ESMTP id CBB7EE6E41
	for <fio@vger.kernel.org>; Fri,  8 Nov 2013 13:11:28 +0000 (GMT)
Received: from [192.168.2.50] (unknown [93.89.81.205])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by muon.cran.org.uk (Postfix) with ESMTPSA id A68C2E6E40
	for <fio@vger.kernel.org>; Fri,  8 Nov 2013 13:11:28 +0000 (GMT)
Message-ID: <527CE300.8010300@cran.org.uk>
Date: Fri, 08 Nov 2013 13:11:28 +0000
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: Warnings from gcc 4.9 (on FreeBSD)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

Building using gcc 4.9 (on FreeBSD 11-CURRENT) generates a few warnings 
about undefined behaviour:

     CC cconv.o
In file included from thread_options.h:5:0,
                  from cconv.c:3:
cconv.c: In function 'convert_thread_options_to_cpu':
os/os.h:197:16: warning: iteration 2u invokes undefined behavior 
[-Waggressive-loop-optimizations]
   __le32_to_cpu(*__val);   \
                 ^
os/os.h:176:28: note: in definition of macro '__le32_to_cpu'
  #define __le32_to_cpu(x)  (x)
                             ^
cconv.c:78:17: note: in expansion of macro 'le32_to_cpu'
    o->rwmix[i] = le32_to_cpu(top->rwmix[i]);
                  ^
cconv.c:63:2: note: containing loop
   for (i = 0; i < DDIR_RWDIR_CNT; i++) {
   ^
In file included from thread_options.h:5:0,
                  from cconv.c:3:
cconv.c: In function 'convert_thread_options_to_net':
os/os.h:209:16: warning: iteration 2u invokes undefined behavior 
[-Waggressive-loop-optimizations]
   __cpu_to_le32(*__val);   \
                 ^
os/os.h:179:28: note: in definition of macro '__cpu_to_le32'
  #define __cpu_to_le32(x)  (x)
                             ^
cconv.c:372:19: note: in expansion of macro 'cpu_to_le32'
    top->rwmix[i] = cpu_to_le32(o->rwmix[i]);
                    ^
cconv.c:352:2: note: containing loop
   for (i = 0; i < DDIR_RWDIR_CNT; i++) {
   ^
In file included from thread_options.h:5:0,
                  from cconv.c:3:
cconv.c: In function 'fio_test_cconv':
os/os.h:209:16: warning: iteration 2u invokes undefined behavior 
[-Waggressive-loop-optimizations]
   __cpu_to_le32(*__val);   \
                 ^
os/os.h:179:28: note: in definition of macro '__cpu_to_le32'
  #define __cpu_to_le32(x)  (x)
                             ^
cconv.c:372:19: note: in expansion of macro 'cpu_to_le32'
    top->rwmix[i] = cpu_to_le32(o->rwmix[i]);
                    ^
cconv.c:352:2: note: containing loop
   for (i = 0; i < DDIR_RWDIR_CNT; i++) {
   ^
In file included from thread_options.h:5:0,
                  from cconv.c:3:
os/os.h:197:16: warning: iteration 2u invokes undefined behavior 
[-Waggressive-loop-optimizations]
   __le32_to_cpu(*__val);   \
                 ^
os/os.h:176:28: note: in definition of macro '__le32_to_cpu'
  #define __le32_to_cpu(x)  (x)
                             ^
cconv.c:78:17: note: in expansion of macro 'le32_to_cpu'
    o->rwmix[i] = le32_to_cpu(top->rwmix[i]);
                  ^
cconv.c:63:2: note: containing loop
   for (i = 0; i < DDIR_RWDIR_CNT; i++) {
   ^

-- 
Bruce Cran
