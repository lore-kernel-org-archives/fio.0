Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D437281368
	for <fio@vger.kernel.org>; Tue,  6 May 2025 13:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746538139; cv=none; b=GbEfzzxOcS41bN6o7Ovi21vCQC5KaXXyO3xTUO/plr4rxF/PRJEBEkTMf+PHGL31usRAT1Apf9cGIkpMDBlZCaPSBSEpkXlbQkn4LLxn5RylP8guKKHZnB2ljyY+h3NuG9WRBpRaU9hLCBWlL4mRHVMFxKoyFeGyLyZ6Vw917Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746538139; c=relaxed/simple;
	bh=p3YRxk977GAIIR2eQ/dkW5OGCfyVWsJp4By4bbCoQ/E=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=L7hVhalGWwYKGe6bhZVcnxPHrWNYCz3T4qxtdbLOwuVMBJA7kK/syDbOI8bfdc/xxIE/VXhDPfzOqK135A6f8/gyLEMGstq6WXPtSNjzOR+gLmSEy38OOzO76U4D2urp84ba3tpUMwcc07jz+HHKDehy58lYpeLj2npuHtpaNh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=web_rene@gmx.de header.b=RsXost2S; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=web_rene@gmx.de header.b="RsXost2S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1746538135; x=1747142935; i=web_rene@gmx.de;
	bh=a6WhsRRpiOWjBN2AA05i53fXfgGw/f4vS1d0O2U4Q08=;
	h=X-UI-Sender-Class:Content-Type:Mime-Version:Subject:From:
	 In-Reply-To:Date:Cc:Content-Transfer-Encoding:Message-Id:
	 References:To:cc:content-transfer-encoding:content-type:date:from:
	 message-id:mime-version:reply-to:subject:to;
	b=RsXost2SnZF7JlS58qO/uaFqNpw2625hKAvgxLA10+SHFTaZbmpiChAeHDVgEZ6J
	 CdsSJKrNuEf8kskneu+q1kUMVc4dfsF5yZZjp+b00N7nukCajmL3hYTc63WRPc2bc
	 ksfxeJ2A/Rvn0f10hpTp9bySC8irFnW4UzbgXf27dz4v+Y56nEEWMMubc2J1SlCfu
	 XJB6/PuPmaVrH80hIhRBEw3dgF9a/C+1BNCESUWbSxZPli8V22jC1bDWjtEG2Yrl8
	 XjGnoWs6LM+m6YPtxUagD/erfEuNf7SBEz8giiKT/iV0Nn0UPsDlrql9ra1P1F1xF
	 QBD0nWZNqCli02BjOg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from smtpclient.apple ([188.193.140.203]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MFKKX-1uEoWs2Rab-008pMz; Tue, 06
 May 2025 15:28:55 +0200
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.500.181.1.5\))
Subject: Re: Aggregated results too high when using multiple servers via
 "client" command
From: =?utf-8?Q?Ren=C3=A9_Weber?= <web_rene@gmx.de>
In-Reply-To: <CALjAwxgRZv8mO0yTNxyZ_io6=eLSLdWbdoDsqs7HyKqzZcX+mg@mail.gmail.com>
Date: Tue, 6 May 2025 15:28:44 +0200
Cc: fio@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <6D52FD70-46C8-4603-A26D-75D8BE3AAABF@gmx.de>
References: <8C4338A1-1AA8-4D3B-B862-DC07F5DB5757@gmx.de>
 <CALjAwxiN9VDP94L6YQs8c4bzGngPH3jm7H+ThTKOXxaq4-C2Cw@mail.gmail.com>
 <46404378-9707-4EB0-9832-1BB2E37C1F51@gmx.de>
 <CALjAwxgRZv8mO0yTNxyZ_io6=eLSLdWbdoDsqs7HyKqzZcX+mg@mail.gmail.com>
To: Sitsofe Wheeler <sitsofe@gmail.com>
X-Mailer: Apple Mail (2.3826.500.181.1.5)
X-Provags-ID: V03:K1:UEnHtL89/B+IaVIlcIfElhE1pn+CNGmufhOA1Msd2UkkYuckJ4j
 hGOGreCeR+ftP1CsNlYaX2PLrmDdMu9VYzkhUobRcN01fV53yVkIGcI3aYHpZfMT7PZHWon
 tuRZ95zqCvpO88Gd0zynPTq0XUOaCP1KKVMLEz5SLqSZp4PJkYjerUnQa2rte+loCl0ikUf
 2Ygr9PQIwykS5sa3tk0DA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Pe32+9+i04Y=;uI4PLtfkm9ubH73+2qIuUVfWq3I
 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
 qiIN1k0gBttOcbAg1aQBul/y9R+6H2EuqL


Unfortunately not. But I did some more research and my best guess at the =
moment is that FIO is correct and I am only testing the caching engine =
on the target.
I did some restore tests as well which did also over perform but I did =
see barely disk access on the the target site.=20
My target machine is a Linux with a ZFS File System, connected via SMB. =
The system comes with 128GB RAM.=20
I tried increasing the filesize to over 128GB which reduces the =
summarized performance on write but not on read.
I tried mounting the volume with gifs option cache=3Dnone without =
effect.
Funny enough when not using multi-client but 6 parallel jobs I get the =
same too-high values as initially with multi-client configuration.

So I guess it is rather a general setup problem and less a bug. =
Nevertheless I would be happy to get a good advice...



> Am 05.05.2025 um 23:33 schrieb Sitsofe Wheeler <sitsofe@gmail.com>:
>=20
> On Mon, 5 May 2025 at 11:56, Ren=C3=A9 Weber <web_rene@gmx.de> wrote:
>>=20
>> You are absolutely right. Lots of details missing indeed=E2=80=A6
>>=20
>> fio-3.36 on Ubuntu 24.04.2 LTS
>>=20
>> Command:
>> fio --client=3Dconfigs/host.list fio-configs/test.job =
--output=3Dtest.output --output-format=3Djson
>>=20
>> cat test.job:
>> [global]
>> filename=3D/mnt/benchmark/testfile.dat
>> group_reporting
>> write_bw_log=3Daggregated
>>=20
>> [Full Write]
>> size=3D25G
>> bs=3D512K
>> rw=3Dwrite
>> ioengine=3Dlibaio
>> direct=3D1
>> time_based
>> runtime=3D60s
>>=20
>> cat host.list
>> 10.100.12.51
>> 10.100.12.52
>> 10.100.12.53
>> 10.100.12.54
>>=20
>> My target is a NAS device mounted via CIFS/SMB under /mnt/benchmark/
>> I played around with write_bw_log=3Daggregated and group_reporting, =
but in the end the summarized Bandwidth  is always higher than my target =
device overall performance.
>=20
> Is there any difference in performance numbers if you add end_fsync=3D1
> to the job file?
>=20
> --=20
> Sitsofe


