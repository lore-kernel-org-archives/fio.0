Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-vk0-f48.google.com ([209.85.213.48]:44455 "EHLO
        mail-vk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754184AbeCHPQZ (ORCPT <rfc822;fio@vger.kernel.org>);
        Thu, 8 Mar 2018 10:16:25 -0500
Received: by mail-vk0-f48.google.com with SMTP id t126so3873268vkb.11
        for <fio@vger.kernel.org>; Thu, 08 Mar 2018 07:16:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <ACD20EC0-F2EA-4344-8F1A-7F9CEBFE2E38@nutanix.com>
References: <e044afaa-22ad-c7e2-d041-e2658f49bac8@bluestop.org>
 <CALjAwxjoTtRp1jVhfKMTcbn6wnmEmmCsjkpO7CkBgF5zj4B3Bg@mail.gmail.com>
 <9cf7d62a-5c4a-737a-d119-13763fb42c72@bluestop.org> <CALjAwxhxpLuLeysnp5kC-kQoWH++4hvehCWJxc9yA_Fcsy=pmw@mail.gmail.com>
 <BAE7B5AF-63F9-4E95-940D-7C84CE5AD92E@nutanix.com> <36259BEC-1CF0-45A5-85AE-F557989EDF30@nutanix.com>
 <2B8D69D8-05F3-4500-8A4E-F5DE21356676@nutanix.com> <CALjAwxiTX1=7pJKQ1Lz7nDkMXZqVJkMkNZDOA_XJYsEGP7wSfw@mail.gmail.com>
 <971ECD81-B100-4EEE-98CE-0E578A59BB02@nutanix.com> <7B5FFC71-BE67-435F-8DE6-8376E52754EB@nutanix.com>
 <ACD20EC0-F2EA-4344-8F1A-7F9CEBFE2E38@nutanix.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Thu, 8 Mar 2018 15:15:53 +0000
Message-ID: <CALjAwxgFV78VOikrYup_6AzkfHu5+1PNB3asyraC5Hm9C5Yp5Q@mail.gmail.com>
Subject: Re: Windows: FIO randomly hangs using attached script
Content-Type: text/plain; charset="UTF-8"
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Rob Scheepens <rob.scheepens@nutanix.com>
Cc: David Knierim <knierim@nutanix.com>, Rebecca Cran <rebecca@bluestop.org>, fio <fio@vger.kernel.org>

I've no good ideas on that one. Could be due to permissions or lack of
space on gdb's current working directory? Perhaps take a look with pwd
and change it with cd?

On 8 March 2018 at 14:38, Rob Scheepens <rob.scheepens@nutanix.com> wrote:
> Btw.: this is the error I got when trying to generate a dump:
>
> (gdb) generate-core-file
> warning: cannot close "core.3784": Invalid operation
> Can't create a corefile
> (gdb)

-- 
Sitsofe | http://sucs.org/~sits/
