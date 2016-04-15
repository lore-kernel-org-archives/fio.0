Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:33401 "EHLO
	mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbcDODT0 (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 14 Apr 2016 23:19:26 -0400
Received: by mail-vk0-f67.google.com with SMTP id v68so13075912vka.0
        for <fio@vger.kernel.org>; Thu, 14 Apr 2016 20:19:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <6970D64051BC6047987810C1EE37A0351B6957A9@SSIEXCH-MB3.ssi.samsung.com>
References: <6970D64051BC6047987810C1EE37A0351B6956EA@SSIEXCH-MB3.ssi.samsung.com>
	<CALjAwxhD2PW239kH03uuOiaEgaeW8Gn+sFAOytHpUHXHgeXcFA@mail.gmail.com>
	<6970D64051BC6047987810C1EE37A0351B6957A9@SSIEXCH-MB3.ssi.samsung.com>
Date: Fri, 15 Apr 2016 04:19:25 +0100
Message-ID: <CALjAwxiRaX5v=v00DhrX2=CS0GwsgHiiw62qgvb5NFumibb2xw@mail.gmail.com>
Subject: Re: sector size other than 512 bytes
From: Sitsofe Wheeler <sitsofe@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "TK (Tzung-Kwang) Wang-SSI" <tk.wang@ssi.samsung.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

On 14 April 2016 at 21:06, TK (Tzung-Kwang) Wang-SSI
<tk.wang@ssi.samsung.com> wrote:
> Yes, according to sg_readcap output.

It ought to be the same but what about via

/sys/block/<device>/queue/logical_block_size

?

-- 
Sitsofe | http://sucs.org/~sits/
