Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vc0-f170.google.com ([209.85.220.170]:53839 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785Ab3AKTYT (ORCPT <rfc822;fio@vger.kernel.org>);
	Fri, 11 Jan 2013 14:24:19 -0500
Received: by mail-vc0-f170.google.com with SMTP id fl11so1795706vcb.15
        for <fio@vger.kernel.org>; Fri, 11 Jan 2013 11:24:19 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 11 Jan 2013 11:24:18 -0800
Message-ID: <CAJdxx76y1m6NG9_D86XXY4xz2mJc4guP1Qa_DCqNQNamNPxK7w@mail.gmail.com>
Subject: asking for an example job file
From: Hong Jiang <hong@maginatics.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio <fio@vger.kernel.org>

Hi there,

I am pretty new to this tool, and currently evaluating it on both
linux and windows platforms.  Would appreciate if someone shows me an
example of job file that can test this scenario:

I have a share that's created out of the "cloud", on windows client
side it's mounted as a new drive, on linux it's mounted to a
directory.  I would like to run some file op tests against the share.

I tried to use the example job file that came with the package -
1mbs_clients, modifying the "directory" parameter setting in the file,
but I am not sure it's really running against the share, as the result
looks exact the same when I ran the test on 2 different shares.

Thanks in advance for your help!

Hong
