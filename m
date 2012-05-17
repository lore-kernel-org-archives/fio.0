Return-Path: <fio-owner@vger.kernel.org>
Received: from mail-out2.uio.no ([129.240.10.58]:56844 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135Ab2EQQRC (ORCPT <rfc822;fio@vger.kernel.org>);
	Thu, 17 May 2012 12:17:02 -0400
Received: from mail-mx3.uio.no ([129.240.10.44])
	by mail-out2.uio.no with esmtp (Exim 4.75)
	(envelope-from <jarle.bjorgeengen@usit.uio.no>)
	id 1SV3Ns-0003QJ-GN
	for fio@vger.kernel.org; Thu, 17 May 2012 18:17:00 +0200
Received: from 7.123.45.31.customer.cdi.no ([31.45.123.7] helo=heritage.uio.no)
	by mail-mx3.uio.no with esmtpsa (TLSv1:AES256-SHA:256)
	user jb (Exim 4.76)
	(envelope-from <jarle.bjorgeengen@usit.uio.no>)
	id 1SV3Ns-0008LY-0H
	for fio@vger.kernel.org; Thu, 17 May 2012 18:17:00 +0200
Message-ID: <4FB52477.4050407@usit.uio.no>
Date: Thu, 17 May 2012 18:16:55 +0200
From: =?ISO-8859-1?Q?Jarle_Bj=F8rgeengen?= 
	<jarle.bjorgeengen@usit.uio.no>
Reply-To: fio@vger.kernel.org
MIME-Version: 1.0
Subject: Re: blktrace with fio replay for benchmarking vendor offerings
References: <4FB3FE27.3030302@usit.uio.no> <4FB417E0.5080802@cesnet.cz>
In-Reply-To: <4FB417E0.5080802@cesnet.cz>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
Content-Transfer-Encoding: quoted-printable
Sender: fio-owner@vger.kernel.org
List-Id: fio@vger.kernel.org
To: 
Cc: fio@vger.kernel.org

On 05/16/2012 11:10 PM, Jiri Horky wrote:
> Hi Jarle,
>
> On 05/16/2012 09:21 PM, Jarle Bj=EF=BF=BDrgeengen wrote:
>> Hello,
>>
>> I'm involved in the purchasing process of block storage systems, and
>> research viable benchmarking strategies for specifying and verifying
>> performance requirements.
>>
>> Ideally I would like to capture our traces of our current daily
>> production workload with blktrace, attach the traces to the tender and
>> require the configuration to be able to run 2x that kind of workload.
>> During acceptance I would like to hook enough hardware to saturate the
>> system with the same workload, and measure that the requirement has
>> been met.
>>
>> I'm interested in comments about the practical viability of such
>> approach if anyone have similar experiences.
>>
> actually, I am in the very same situation at Institute of Physics, where
> we annually buy some 1PB of raw disk space (the money equivalent). We
> ended up with very similar approach that you described. We use IOreplay
> from IOapps (http://code.google.com/p/ioapps/) application to run the
> load previously recorded by strace. So it is done on a file level
> instead of the block level. This clearly has its advantages (you may use
> different file system, benchmarks are not fatal for running systems
> etc.), but of course some drawbacks as well (strace overhead, etc., see
> webpage). If you are interested and have any more question/suggestion
> about the IOreplay, just email me, I actually wrote it as a part of my
> master thesis.

Thanks for the tip I'll check out IOapps.

>> Some open questions:
>>
>> How safe is it to run blktrace on critical production environment?
>> What precautions should be made?
>>
>> Given that the current system consists of 3 HP EVA800 with X number of
>> LUNS about 50 hosts, and the new system likely is a single system with
>> 5 new servers running at at full speed, how much value will the
>> benchmark provide compared to "real world" ? Should I create equally
>> many luns and distribute load across the 5 machines?
>>
>> Is it best to scale the workload to 2X replaying all traces
>> simultanously with one fio-trace-replay/lun, and then dublicate alle
>> replays so that each lun serves two fio-replays rather than one, and
>> then 3 and so on.
>>
>> Any thoughts or comments are very much appreciated.
> I would say that all above heavily depends on your environment, whether
> the access pattern is similar to all LUNS and whether all LUNS are more
> or less expected to expand similarly in the future. Personally, I would
> go with settings that are simpler to setup (from the options you have
> proposed) unless you really know your future requirements and you are
> sure that the results obtained in both ways differ significantly.

Thanks.

- Jarle Bj=EF=BF=BDrgeengen
