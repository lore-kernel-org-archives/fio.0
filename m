Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:60990 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756806Ab3HFXT2 (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 6 Aug 2013 19:19:28 -0400
Received: by mail-we0-f182.google.com with SMTP id u55so950255wes.13
        for <fio@vger.kernel.org>; Tue, 06 Aug 2013 16:19:26 -0700 (PDT)
MIME-Version: 1.0
Reply-To: jiahua@gmail.com
Date: Tue, 6 Aug 2013 16:19:26 -0700
Message-ID: <CA+S_sg4sVwquhtxLpmjQQXiNOBya+6vF0mSbyWZG_Q1YtbPPCA@mail.gmail.com>
Subject: How to control the number of random I/O's acrossing the whole file/device?
From: Jiahua <jiahua@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi all,

What I want is to touch a file/device randomly but up to a given
number of times. I tried the "size=" option but it also limits the
file size. Is there a way to do that instead of time_based, which is
approximate to my requirement?

Thanks,
Jiahua
