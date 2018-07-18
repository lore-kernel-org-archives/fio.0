Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-eopbgr40048.outbound.protection.outlook.com ([40.107.4.48]:34064
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726427AbeGRIvo (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 18 Jul 2018 04:51:44 -0400
From: Adam Abed Abud <adam.abed.abud@cern.ch>
Subject: FIO mixed tests with different patters and block sizes
Message-ID: <c574a91d-0d38-03d8-dc44-37f5662a6e52@cern.ch>
Date: Wed, 18 Jul 2018 10:14:42 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hello,

I'm using FIO for testing some distributed file systems and I am 
interested in running a single test where I have a mix of both reading 
and writing. The problem is that I want to have different access 
patterns (e.g. sequential writing and random reading) and different 
block sizes. How can I run such a job?

Thanks a lot,
Adam
