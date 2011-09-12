Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vw0-f43.google.com ([209.85.212.43]:43130 "EHLO
	mail-vw0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019Ab1ILEd4 (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 12 Sep 2011 00:33:56 -0400
Received: by vws10 with SMTP id 10so3974031vws.2
        for <fio@vger.kernel.org>; Sun, 11 Sep 2011 21:33:56 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 11 Sep 2011 21:33:55 -0700
Message-ID: <CAKa9NmvPyvyrdbpYaHoo20yu5Gbsq1m_GYzUen2viOUZkJdQHQ@mail.gmail.com>
Subject: runtime option not working similar for all devices
From: Vikram Seth <seth.vik@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I am testing random reads on raw devices (hdd and flash) in a host. I
set same runtime value (12 hrs) in test file for each device.
However, while the test is running the ETA for hdd test (11:53 hrs) is
shown as more than twice of flash (4:40hrs). Later the test for flash
completes while the hdd test is still running.

I thought that having same runtime will cause the test to run for same
amount of time on all devices.
Is that not true ?

Thanks,
Vikram.
