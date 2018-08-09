Return-Path: <fio-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.3]:59669 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730813AbeHIQjM (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 9 Aug 2018 12:39:12 -0400
MIME-Version: 1.0
Message-ID: <trinity-501fac2d-a584-4e9d-8dd4-a0ffdc09985f-1533824046447@3c-app-webde-bs25>
From: c.monty@web.de
Subject: How to fio benchmark on RAID device avoiding any caching
Content-Type: text/plain; charset=UTF-8
Date: Thu, 9 Aug 2018 16:14:06 +0200
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

can you recommend a fio setting for benchmarking a RAID device that is bypassing any caching effects in case RAID controller has cache enabled?

THX
