Return-Path: <fio-owner@vger.kernel.org>
Received: from mail.yuiop.co.uk ([89.145.97.74]:50318 "EHLO mail.yuiop.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753882Ab2CLQjt (ORCPT <rfc822;fio@vger.kernel.org>);
	Mon, 12 Mar 2012 12:39:49 -0400
Message-ID: <4F5E22F9.1040208@anonymous.org.uk>
Date: Mon, 12 Mar 2012 16:23:21 +0000
From: John Robinson <john.robinson@anonymous.org.uk>
MIME-Version: 1.0
Subject: Re: Striping does not increase performance.
References: <CAKFseUN8-Rb1x5j-JM+q3CLEXnFO0ieAmBG_5tVcxu4NAz0ojA@mail.gmail.com> <20120312125720.GL4558@voyageur.mas.nom.fr> <CAKFseUO5CVHBLhcY19DWzqhf-Ebrn7c-=iwxANuRcqwTV0PyBg@mail.gmail.com> <20120312135847.GM4558@voyageur.mas.nom.fr> <4F5E0963.6080708@cesnet.cz>
In-Reply-To: <4F5E0963.6080708@cesnet.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: Jiri Horky <jiri.horky@cesnet.cz>
Cc: Erwan MAS <erwan@mas.nom.fr>, Caspar Smit <c.smit@truebit.nl>, linux-raid@vger.kernel.org, fio@vger.kernel.org

On 12/03/2012 14:34, Jiri Horky wrote:
> Hi,
>
> as for alignment, please also check md metadata format version (-e
> switch of mdadm). The version that ensures alignment is 1.0, which
> places the metadata information to the back of the drive.

As far as I can tell from looking at the source, ever since the 1.x 
metadata types were introduced (with mdadm 2.0, in August 2005):

* the data offset on 1.1 and 1.2 arrays has always been 4K-aligned,
* the superblock offset for 1.0 arrays has always been 4K-aligned,
* the bitmap offset for all 1.x arrays has always been 4K-aligned.

As of mdadm 3.1.2 (March 2010), the data offset for new 1.1 and 1.2 
arrays is always 1MB (2048 sectors), so they're also 1M-aligned.

Cheers,

John.

