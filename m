Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39523 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab1BNIIG (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 14 Feb 2011 03:08:06 -0500
Received: by iyj8 with SMTP id 8so4546224iyj.19
        for <fio@vger.kernel.org>; Mon, 14 Feb 2011 00:08:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20cf30564493a84040049c39612f@google.com>
References: <AANLkTin2ZjkkFOrwo++EZw0arQnsMrqzy0drUF6WrqDm@mail.gmail.com>
	<20cf30564493a84040049c39612f@google.com>
Date: Mon, 14 Feb 2011 16:08:06 +0800
Message-ID: <AANLkTikCqfuWKFQU0w=0N6n-C9d-VNUvB1XF+mzXzewp@mail.gmail.com>
Subject: Re: Delivery Status Notification (Failure)
From: wu meng <james.wumeng@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: fio@vger.kernel.org

Hi,

I've a problem on using fio:
"buffered=bool If value is true, use buffered io. This is the opposite
of the 'direct' option. Defaults to true."
So what kind of buffer mean for this option? Is that mean kernel cache
or user space buffer?
