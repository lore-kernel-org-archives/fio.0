Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49395 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754978Ab2CLNCg convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Mon, 12 Mar 2012 09:02:36 -0400
MIME-Version: 1.0
In-Reply-To: <20120312125720.GL4558@voyageur.mas.nom.fr>
References: <CAKFseUN8-Rb1x5j-JM+q3CLEXnFO0ieAmBG_5tVcxu4NAz0ojA@mail.gmail.com>
	<20120312125720.GL4558@voyageur.mas.nom.fr>
Date: Mon, 12 Mar 2012 14:02:36 +0100
Message-ID: <CAKFseUO5CVHBLhcY19DWzqhf-Ebrn7c-=iwxANuRcqwTV0PyBg@mail.gmail.com>
Subject: Re: Striping does not increase performance.
From: Caspar Smit <c.smit@truebit.nl>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Erwan MAS <erwan@mas.nom.fr>
Cc: linux-raid@vger.kernel.org, fio@vger.kernel.org

Hi Erwan,

I do not use partitions on the drives so the whole disk /dev/sdb is
used as md component device, i was in the understanding that if not
using partitions the alignment is correct or am i wrong?

Kind regards,

Caspar Smit

Op 12 maart 2012 13:57 heeft Erwan MAS <erwan@mas.nom.fr> het volgende
geschreven:
> On Mon, Mar 12, 2012 at 01:34:08PM +0100, Caspar Smit wrote:
>> Hi all,
>>
>> I don't know exactly which mailinglists to use for this one so I hope
>> i used the right ones.
>>
>> I did some performance testing on a new system and found out some
>> things I couldn't explain or didn't expect.
>> At the end are some questions I hope to get answered to explain the
>> tings i'm seeing in the test.
>>
>> First of all a description of my setup.
>>
>> The server is a 36 bay 3,5" supermicro chassis filled with 36x 2TB
>> SATA 7200 RPM disks.
>> [../..]
>
> Please check alignement of each level of stockage .
> Because this disk present to controller a block size of 512 bytes , but i=
nternal
> use a 4k block size .
>
> You must check that alignement is correct for :
> =EF=BF=BDdisk partionnemnt
> =EF=BF=BDmd device
> =EF=BF=BDpv lvm
>
> --
> =EF=BF=BD =EF=BF=BD _____________________________________________________=
_______
> =EF=BF=BD =EF=BF=BD/ Erwan MAS =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =
=EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=
=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=
=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD /\
> =EF=BF=BD | mailto:erwan@mas.nom.fr =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=
=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =
=EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD =EF=BF=BD |_/
> ___|________________________________________________________ =EF=BF=BD |
> \___________________________________________________________\__/
