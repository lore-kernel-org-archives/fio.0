Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:36092 "EHLO
	mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbcDNTp7 convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Thu, 14 Apr 2016 15:45:59 -0400
Received: by mail-vk0-f67.google.com with SMTP id x190so11939260vka.3
        for <fio@vger.kernel.org>; Thu, 14 Apr 2016 12:45:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6970D64051BC6047987810C1EE37A0351B6956EA@SSIEXCH-MB3.ssi.samsung.com>
References: <6970D64051BC6047987810C1EE37A0351B6956EA@SSIEXCH-MB3.ssi.samsung.com>
Date: Thu, 14 Apr 2016 20:45:53 +0100
Message-ID: <CALjAwxhD2PW239kH03uuOiaEgaeW8Gn+sFAOytHpUHXHgeXcFA@mail.gmail.com>
Subject: Re: sector size other than 512 bytes
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "TK (Tzung-Kwang) Wang-SSI" <tk.wang@ssi.samsung.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 14 April 2016 at 19:44, TK (Tzung-Kwang) Wang-SSI
<tk.wang@ssi.samsung.com> wrote:
>
> I have been using FIO on SATA drives for some times and all were fine until recently I added SAS drives to the test list. Some of the SAS drives have 520-byte sector size, with DIF, and my FIO setup was not able to run on those drives. I have not found related postings in archive for possible workaround. My had also upgrade from v2.1.14 to v2.8 with the same result.
>
> Is there a patch available for supporting sector size other than 512-byte for either Windows 7 and/or Ubuntu 14 LTS environment?

Does linux report the block size as 520 in /sys ?

-- 
Sitsofe | http://sucs.org/~sits/
