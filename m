Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vb0-f45.google.com ([209.85.212.45]:45894 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab3DOHHi (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 15 Apr 2013 03:07:38 -0400
Received: by mail-vb0-f45.google.com with SMTP id w15so3533141vbf.18
        for <fio@vger.kernel.org>; Mon, 15 Apr 2013 00:07:37 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 15 Apr 2013 17:07:37 +1000
Message-ID: <CAKCZDgnCkwNGFVrWE706Z4S4MYra+XfeOqSV80n-QhDnoVPBuQ@mail.gmail.com>
Subject: Unit Prefixes
From: Aaron Carroll <xaaronc@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>

I just noticed that the binary/decimal unit prefixes are around the
wrong way, in that [KMG]iB is treated as base-10, and [kMG]B as
base-2.

Is this intentional?


  -- Aaron
