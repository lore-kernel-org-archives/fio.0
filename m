Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f68.google.com ([209.85.213.68]:36770 "EHLO
	mail-vk0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbcDSFfG (ORCPT <rfc822;fio@vger.kernel.org>);
	Tue, 19 Apr 2016 01:35:06 -0400
Received: by mail-vk0-f68.google.com with SMTP id x190so791001vka.3
        for <fio@vger.kernel.org>; Mon, 18 Apr 2016 22:35:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6970D64051BC6047987810C1EE37A0351B698AB0@SSIEXCH-MB3.ssi.samsung.com>
References: <6970D64051BC6047987810C1EE37A0351B6956EA@SSIEXCH-MB3.ssi.samsung.com>
	<CALjAwxhD2PW239kH03uuOiaEgaeW8Gn+sFAOytHpUHXHgeXcFA@mail.gmail.com>
	<6970D64051BC6047987810C1EE37A0351B6957A9@SSIEXCH-MB3.ssi.samsung.com>
	<CALjAwxiRaX5v=v00DhrX2=CS0GwsgHiiw62qgvb5NFumibb2xw@mail.gmail.com>
	<6970D64051BC6047987810C1EE37A0351B695F5F@SSIEXCH-MB3.ssi.samsung.com>
	<CALjAwxhktXN=-PqpebHOgq2RzhD6HrzDW101gpjArh=3J6o2pQ@mail.gmail.com>
	<6970D64051BC6047987810C1EE37A0351B698AB0@SSIEXCH-MB3.ssi.samsung.com>
Date: Tue, 19 Apr 2016 06:35:05 +0100
Message-ID: <CALjAwxj5-vksRHeD9edhp=uCgvp6GBwCpbbnLDNqHzQU+5+S8w@mail.gmail.com>
Subject: Re: sector size other than 512 bytes
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "TK (Tzung-Kwang) Wang-SSI" <tk.wang@ssi.samsung.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 18 April 2016 at 21:56, TK (Tzung-Kwang) Wang-SSI
<tk.wang@ssi.samsung.com> wrote:
>
> Yes, dmesg shows "Unsupported sector size 520.". So solution for this issue is have 520-byte sector size support in linux device driver, it seems.

You might find the sg ioengine works but if it depends on regular
block device commands to get information (e.g. the disk size) then
things might fail before I/O can be submitted.

In a previous message you mention DIF (the data integrity extensions)
but to use that it's worth noting your driver and controller have to
support it in addition to the disk. Perhaps you can use lsscsi's
--protection and --protmode to find out what's available? Here's what
Red Hat had to say about DIF support in RHEL 6:
https://access.redhat.com/solutions/41548 but I don't know if that
impacts your case.

-- 
Sitsofe | http://sucs.org/~sits/
