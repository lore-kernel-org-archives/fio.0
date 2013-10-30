Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.cran.org.uk ([93.89.92.64]:58750 "EHLO muon.cran.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754228Ab3J3OHB (ORCPT <rfc822;fio@vger.kernel.org>);
	Wed, 30 Oct 2013 10:07:01 -0400
Received: from muon.cran.org.uk (localhost [127.0.0.1])
	by muon.cran.org.uk (Postfix) with ESMTP id ACC04E6E3B
	for <fio@vger.kernel.org>; Wed, 30 Oct 2013 14:00:36 +0000 (GMT)
Received: from [192.168.2.50] (unknown [93.89.81.205])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by muon.cran.org.uk (Postfix) with ESMTPSA id 857C3E6E3A
	for <fio@vger.kernel.org>; Wed, 30 Oct 2013 14:00:36 +0000 (GMT)
Message-ID: <52711104.3020604@cran.org.uk>
Date: Wed, 30 Oct 2013 14:00:36 +0000
From: Bruce Cran <bruce@cran.org.uk>
MIME-Version: 1.0
Subject: Bug in x86_64 do_cpuid()
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

It seems there's a bug in the x86_64 version of do_cpuid() that causes 
fio to segfault when built with clang at lower optimization levels:

static inline void do_cpuid(unsigned int *eax, unsigned int *ebx,
                 unsigned int *ecx, unsigned int *edx)
{
     asm volatile("cpuid"
         : "=a" (*eax), "=b" (*ebx), "=r" (*ecx), "=d" (*edx)
         : "0" (*eax), "2" (*ecx)
         : "memory");
}

via Tijl Coosemans:

Should be: "=c" (*ecx)

But you can also use the '+' modifier and remove the input operands:

: "+a" (*eax), "=b" (*ebx), "+c" (*ecx), "=d" (*edx)
:
: "memory"

-- 
Bruce Cran
