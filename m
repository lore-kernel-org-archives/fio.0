Return-Path: <fio-owner@vger.kernel.org>
Received: from edge20.ethz.ch ([82.130.99.26]:18073 "EHLO edge20.ethz.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757577Ab1COMm4 convert rfc822-to-8bit (ORCPT
	<rfc822;fio@vger.kernel.org>); Tue, 15 Mar 2011 08:42:56 -0400
From: "N. Harake" <hussein@cscs.ch>
Subject: Re: memory caching 
Date: Tue, 15 Mar 2011 12:36:44 +0000
Message-ID: <C9A519EC.108B4%hussein@cscs.ch>
In-Reply-To: <C9A4E18A.10660%hussein@cscs.ch>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <9DA1CC37CC9B964A999E4CF43BF9CFF6@intern.ethz.ch>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: "fio@vger.kernel.org" <fio@vger.kernel.org>


I noticed when I am using --sync=3D1, IOPS go down to 15K and throughput to
53MB (That=EF=BF=BDs horrible for the HW I am using), removing --sync I got=
 150K
IOPS and almost 800MB, which make more sense. What does --sync does, and
hope what I am doing should be enough to avoid any kind of memory caching..

Regards
H. N. Harake

fio --name=3Djob --directory=3D/lvm --size=3D1G --iodepth=3D1 --sync=3D1
--filesize=3D1G --direct=3D1 --numjobs=3D64 --bs=3D4096 --rw=3Drandwrite
--group_reporting

On 3/15/11 9:27 AM, "N. Harake" <hussein@cscs.ch> wrote:

>
>I would like to disable completely the caching in memory, trying to
>measure real throughput read/write and iops on filesystem (not raw
>access).
>Other than direct=3D1 is there any flag I could use to obtain such complete
>bypass caching?
>
>Regards
>H. N. Harake
>--
>To unsubscribe from this list: send the line "unsubscribe fio" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

