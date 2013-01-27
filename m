Return-Path: <fio-owner@vger.kernel.org>
Received: from exprod5og113.obsmtp.com ([64.18.0.26]:35398 "EHLO
	exprod5og113.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755860Ab3A0Tv4 (ORCPT <rfc822;fio@vger.kernel.org>);
	Sun, 27 Jan 2013 14:51:56 -0500
Received: by mail-ee0-f69.google.com with SMTP id e49so2291841eek.4
        for <fio@vger.kernel.org>; Sun, 27 Jan 2013 11:51:54 -0800 (PST)
Received: by mail-bk0-f49.google.com with SMTP id w11so995671bku.22
        for <fio@vger.kernel.org>; Sun, 27 Jan 2013 11:43:57 -0800 (PST)
MIME-Version: 1.0
From: Yufei Ren <yufei.ren@stonybrook.edu>
Date: Sun, 27 Jan 2013 14:43:37 -0500
Message-ID: <CAG5pYQcNzX7LJQeLJCZWK1TRYYQOy5Wy_peKHSoC2OXCiBbYcw@mail.gmail.com>
Subject: Why zipf distribution can not be 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

Is the 'zipf theta' the value of the exponent characterizing the zipf
distribution? If so, why could not it be 1.0? With the following job
file, fio sent out an error - fio: zipf theta must different than 1.0.

[job]
ioengine=null
rw=randread
norandommap
size=1280m
bs=4k
random_distribution=zipf:1

I looked through the fio zipf library but was confused with
zipf_next() function? Any illustration about this zipf distribution
generator?

Thanks
Yufei
