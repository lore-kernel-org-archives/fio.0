Received: from newman.cs.utexas.edu (newman.cs.utexas.edu [128.83.139.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298791CD13
	for <fio@vger.kernel.org>; Wed, 24 Apr 2024 19:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=128.83.139.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713986941; cv=none; b=jw6YnXY3bDNfl3k+riojCRxMs16/S3CO4veXCmJ+ham+fG2HgAod4Dr1NrfZdhTNOHIeRcXCiBp5Z6EJkXaseRyL7REXEEfz6doCBZo3lkLR2doQ71MeYqgsx1TZdpCfQxOUb1CM/4PC8zPJ2L19KhYeN+wkvOTXVLPsHy/2UiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713986941; c=relaxed/simple;
	bh=gkk59H5gKYte+zYCDKNg1j+JrE+/IRixjbDAmAc+9+Y=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=nUKKjnyo8VVfISAnCRShN5SrkeXLkh/XiY1tCR1ubIHlo/owVNsOs5VFkmF4ZVBM4nldLT7zy8ZTIWhiwsvqRA4jXmCR99BH2HdzWFBKTp9xZ+KprWcuCqlGa/+BGq92RUHd0dclynLYKNFwwHObtP/d63P2lE/g6j6BhIOJbqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.utexas.edu; spf=pass smtp.mailfrom=cs.utexas.edu; dkim=pass (1024-bit key) header.d=cs.utexas.edu header.i=@cs.utexas.edu header.b=GyP8W2Ah; arc=none smtp.client-ip=128.83.139.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.utexas.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.utexas.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cs.utexas.edu header.i=@cs.utexas.edu header.b="GyP8W2Ah"
X-AuthUser: pgoetz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cs.utexas.edu;
	s=default; t=1713986938;
	bh=gkk59H5gKYte+zYCDKNg1j+JrE+/IRixjbDAmAc+9+Y=;
	h=Date:To:From:Subject:From;
	b=GyP8W2AhtnsWOJZp8ftREpbd1ggb4p45tZtUDT3N9x/Asst601+31y76xOxjwn6Uh
	 nI4f8SSP3zF/fEn1k1F26lmYMD1rOE/wkKUAoQvCKaIBlkCPuhj5mZ38lMIPtL1/Om
	 7xvw6XzZBNGdo7qeVHa7F3vsV5GgUSxTT3TAjUBE=
Received: from [128.83.120.185] (texas-tea.cs.utexas.edu [128.83.120.185])
	(authenticated bits=0)
	by newman.cs.utexas.edu (8.14.4/8.14.4/Debian-4.1ubuntu1.1) with ESMTP id 43OJSw7R023204
	(version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
	for <fio@vger.kernel.org>; Wed, 24 Apr 2024 14:28:58 -0500
Message-ID: <8af8b9ad-92dc-41b8-84ae-c4ec91a73cc3@cs.utexas.edu>
Date: Wed, 24 Apr 2024 14:28:58 -0500
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: fio@vger.kernel.org
From: Patrick Goetz <pgoetz@cs.utexas.edu>
Subject: NFS performance surpasses network bandwidth?!
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.9 (newman.cs.utexas.edu [128.83.139.110]); Wed, 24 Apr 2024 14:28:58 -0500 (CDT)
X-Virus-Scanned: clamav-milter 0.103.8 at newman
X-Virus-Status: Clean

Hi -

I must either be doing something wrong or am interpreting the results 
wrong.  I'm running this command on an NFS mounted filesystem:

  $ fio --name=random-write --ioengine=posixaio --rw=randwrite --bs=64k 
--size=256m --numjobs=16 --iodepth=16 --runtime=60 --time_based 
--end_fsync=1

With this result:

Run status group 0 (all jobs):
   WRITE: bw=5258MiB/s (5513MB/s), 152MiB/s-766MiB/s (160MB/s-803MB/s), 
io=498GiB (534GB), run=72987-96944msec


The client system is connected to the NFS server over a single 10Gb/s 
connection.  5 GB/s far exceeds the max bandwidth of the wire!

What am I missing?  I ran the test 3 times, each time checking my 
location to make sure I was in an NFS-mounted directory. One test 
resulted in 3.5GB/s write performance, which is still greater than the 
theoretical max bandwidth for the network connection.

