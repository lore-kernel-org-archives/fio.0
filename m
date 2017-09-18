Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-ua0-f173.google.com ([209.85.217.173]:54394 "EHLO
        mail-ua0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753887AbdIRMBn (ORCPT <rfc822;fio@vger.kernel.org>);
        Mon, 18 Sep 2017 08:01:43 -0400
Received: by mail-ua0-f173.google.com with SMTP id l94so142633ual.11
        for <fio@vger.kernel.org>; Mon, 18 Sep 2017 05:01:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOfm_=UDq1nyY+NygZN5f0x6gBXeXMD5S7o3CXSqa-Wo5pHirQ@mail.gmail.com>
References: <CAOfm_=XZDQaaY99C8i1XFN44mYvLC_2+2dRyKpPY2fb=7Bia1A@mail.gmail.com>
 <CAOfm_=VkkHN6NOeTZH3ShrmYpumbaAKBJnf4dW-nMKiEmS6tzg@mail.gmail.com>
 <CALjAwxg0kcnEY5mdyroXr7kFQYYx-s-zBN_AOmhqTKGmw_71qw@mail.gmail.com> <CAOfm_=UDq1nyY+NygZN5f0x6gBXeXMD5S7o3CXSqa-Wo5pHirQ@mail.gmail.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Mon, 18 Sep 2017 13:01:11 +0100
Message-ID: <CALjAwxj2TLLsZT4Bh9ahiMZpMRkvcC7W2TKiyqx+Bfj9JD5yXA@mail.gmail.com>
Subject: Re: fio-3.0-61-g9acb0 engine libaio not loadable Centos7.3x86_64
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Udi-Yehuda Tamar <udi@excelero.com>
Cc: "fio@vger.kernel.org" <fio@vger.kernel.org>

Hi,

On 18 September 2017 at 12:33, Udi-Yehuda Tamar <udi@excelero.com> wrote:
> I found the issue I was using a tiny base centos some how libaio-devel
> install and recompile fixed it
> + print_config 'Linux AIO support' yes
> + printf '%-30s%s\n' 'Linux AIO support' yes
> Linux AIO support             yes
>
> ty all as always!

You're welcome!

-- 
Sitsofe | http://sucs.org/~sits/
