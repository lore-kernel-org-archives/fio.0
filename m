Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-db8eur05on2135.outbound.protection.outlook.com ([40.107.20.135]:19617
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387696AbgJZUen (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 26 Oct 2020 16:34:43 -0400
From: Erwan Velu <e.velu@criteo.com>
Subject: Question around the time precision
Message-ID: <b1be007c-9ef8-69b8-67b9-cbe69f1f08e9@criteo.com>
Date: Mon, 26 Oct 2020 21:34:38 +0100
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
MIME-Version: 1.0
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello list,

I found pretty handy being able to simulate and control the cpu activity 
by using the cpuio engine.

The actual code is doing a simple nop loop for the expected duration.


I'm thinking about adding other loops like having sse or avx loops to 
stress the CPU differently.

I was wondering how accurate must be the loop. Is there any particular 
expectation or constrains to know ?


Erwan,


