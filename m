Return-Path: <fio-owner@vger.kernel.org>
Received: from muon.bluestop.org ([96.73.9.1]:15264 "EHLO muon.bluestop.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728537AbeIGA5t (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 6 Sep 2018 20:57:49 -0400
From: Rebecca Cran <rebecca@bluestop.org>
Subject: examples .job vs .fio, and the fusion-aw-sync ioengine
Message-ID: <99c83ad8-ac18-363c-30cc-48f42361f1bd@bluestop.org>
Date: Thu, 6 Sep 2018 14:20:41 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org, axboe@kernel.dk

Hi,


I noticed a couple of things when taking a look at the FIO build recently.

First is that there are some example files named "*.job" instead of 
"*.fio" (e.g. fio-rand-read.job) - was that deliberate?


Secondly, I was wondering if it's time to remove the fusion-aw-sync 
("Fusion-io atomic engine") ioengine? My understanding is that it was 
never widely adopted since being introduced around 2013.


-- 
Rebecca


