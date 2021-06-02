Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-eopbgr00102.outbound.protection.outlook.com ([40.107.0.102]:52900
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229607AbhFBQOK (ORCPT <rfc822;fio@vger.kernel.org>);
        Wed, 2 Jun 2021 12:14:10 -0400
From: Erwan Velu <e.velu@criteo.com>
Subject: Github CI is broken because of a clang optimization
Message-ID: <fbbaa8ac-f6bb-4baf-c829-bcd491e3a62a@criteo.com>
Date: Wed, 2 Jun 2021 18:12:24 +0200
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
MIME-Version: 1.0
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi there,


My PR around the exec engine was not passing the CI because of a missing 
stpcpy symbol at link time.

I made some search around that, found the issue and proposed a fix at 
https://github.com/axboe/fio/pull/1233


The issue was around clang 12 which is doing some string optimization by 
using stpcpy we don't have.

This PR is about disabling the implicit stpcpy usage with clang for now.

Note the GCC build was passing.


The CI pass with my patches.


Once merged, I'll rebase my exec-engine PR on top of it.


Erwan,


