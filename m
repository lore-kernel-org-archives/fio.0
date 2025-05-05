Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06ECA1FC0F3
	for <fio@vger.kernel.org>; Mon,  5 May 2025 10:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746442565; cv=none; b=KzwPeWgRHaFRkgI0lrdrmlt0GLCxv6N2b7x/lEZ+KMG8IXlKIRFKwXbbtEGmrjuFLqEcruYu5l1h1CPHe0+skBZkLo8Jt/WB+tFISnYG//11Epna3bE6ouZzwc2C2o2iickBzkvR01xfkLf/IS2vCdcQjM9GdSs1Kex2vjfj36c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746442565; c=relaxed/simple;
	bh=ZIS/0rJ89+fkLvbZ7qadHrekpqfgn4WHwcdw8eYERkM=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=BWiyT0M8DhEwRHvPTHBrP/0AUMHub3VT9xv5R8OvoruXIt2S3WNNcS7TFF8nJASMxZsbmEEFjLi9CjTNPw9HvhZZSKhIAIG0ZrQeFQWSUYpypOiwHDMdod2W2tWqp78DfJI8atHItKy4vcnu9OvezVlDiPufTzWsUi3f25Jis5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=web_rene@gmx.de header.b=lpybFi1y; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=web_rene@gmx.de header.b="lpybFi1y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1746442560; x=1747047360; i=web_rene@gmx.de;
	bh=FGimxTN1J2W/uQFRR2Gdnzywmzzd27G26wYg7wS261g=;
	h=X-UI-Sender-Class:Content-Type:Mime-Version:Subject:From:
	 In-Reply-To:Date:Cc:Content-Transfer-Encoding:Message-Id:
	 References:To:cc:content-transfer-encoding:content-type:date:from:
	 message-id:mime-version:reply-to:subject:to;
	b=lpybFi1yMMK4B+4XkmBuuZk6TA+XOazsQhO8Y+2stdg61OBye961KG8iP0m68eYT
	 ZtJyn8TZh9ozYwt5OzL+OH/KYlVb1yPj/Gj/hMphHcm2Zf+bP683y01vBDrYZaP1d
	 uyJypM+x9bHYWs4HxDpvxVoM6tpGrkc6aWWjsGuMD0Nz8BKN5N7G4PK7gCKfgnx1L
	 e+IIoTfFH8mxvf67p78LtbSObGFfFa7fNNENwamqiJ0AeU+dRhazBE06U+CdZwKWV
	 L7VVhIVuBixdWElnoYvBCnPZXnmTBcIMrnCaKvE3WScdMKGCVcvPGxs6OIKPhcWa9
	 bzvF9LV9zHL3TV2WRA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from smtpclient.apple ([188.193.140.203]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MJVHU-1uRLwW1PKK-00QaHy; Mon, 05
 May 2025 12:56:00 +0200
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
In-Reply-To: <CALjAwxiN9VDP94L6YQs8c4bzGngPH3jm7H+ThTKOXxaq4-C2Cw@mail.gmail.com>
Date: Mon, 5 May 2025 12:55:49 +0200
Cc: fio@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <46404378-9707-4EB0-9832-1BB2E37C1F51@gmx.de>
References: <8C4338A1-1AA8-4D3B-B862-DC07F5DB5757@gmx.de>
 <CALjAwxiN9VDP94L6YQs8c4bzGngPH3jm7H+ThTKOXxaq4-C2Cw@mail.gmail.com>
To: Sitsofe Wheeler <sitsofe@gmail.com>
X-Mailer: Apple Mail (2.3826.500.181.1.5)
X-Provags-ID: V03:K1:BZ5x2bChJYlW5UHsbGF+f+jyjhsoCABwjkqaDo1/3VYXg+l93Pq
 +O90hsGP7ih1BdMfB2vasPI8jXxtgKwyfjuuB7ybLrOCjd+WHfLnMmRU0NK+nZIkwwGZu4a
 +kE4WHhMLnTViKTTOD37anMAlBR2yEwtGuSWw9o9NQNzkk6FS1aTqDmc8GU9hPltao4abYn
 9zaCKo709fj4cx+jVFmNQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:mgJqI6g8tbY=;Ao+QErTdWr5QDj69aC87+TDPapx
 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

You are absolutely right. Lots of details missing indeed=E2=80=A6

fio-3.36 on Ubuntu 24.04.2 LTS

Command:=20
fio --client=3Dconfigs/host.list fio-configs/test.job =
--output=3Dtest.output --output-format=3Djson

cat test.job:
[global]
filename=3D/mnt/benchmark/testfile.dat
group_reporting
write_bw_log=3Daggregated

[Full Write]
size=3D25G
bs=3D512K
rw=3Dwrite
ioengine=3Dlibaio
direct=3D1
time_based
runtime=3D60s

cat host.list
10.100.12.51
10.100.12.52
10.100.12.53
10.100.12.54

My target is a NAS device mounted via CIFS/SMB under /mnt/benchmark/
I played around with write_bw_log=3Daggregated and group_reporting, but =
in the end the summarized Bandwidth  is always higher than my target =
device overall performance.


> Am 02.05.2025 um 09:23 schrieb Sitsofe Wheeler <sitsofe@gmail.com>:
>=20
> Hello Ren=C3=A9,
>=20
> On Wed, 30 Apr 2025 at 08:50, Ren=C3=A9 Weber <web_rene@gmx.de> wrote:
> I am trying to do a benchmark from multiple clients in order to test =
the performance of a NAS device.
> When running the test each of the clients reports a performance of =
~950MB/s. The summarized performance in the log shows 4x950MB/s though =
the NAS device only supports (and shows) a maximum bandwith of 950 MB/s =
in total. To my understanding, the servers I am adressing via =
=E2=80=9Eclient=3Dhost.list=E2=80=9C should generate load in parallel =
which should then reduce each stream to the maximum bandwith supported =
by the NAS divided by the number of clients=E2=80=A6 but somehow each =
client reports the maximum bandwith oft he target and the summary =
therfor is wrong. I tried group_reporting and various other command =
without success.
> Any advice here for a newbie?
>=20
> Could you post the full command line and job files you are using? =
Generally the information requested in =
https://github.com/axboe/fio/blob/master/REPORTING-BUGS is always =
helpful!
>=20
> --=20
> Sitsofe

