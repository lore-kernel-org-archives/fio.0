Received: from newman.cs.utexas.edu (newman.cs.utexas.edu [128.83.139.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300B62C1595
	for <fio@vger.kernel.org>; Mon,  3 Aug 2026 19:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=128.83.139.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785784663; cv=none; b=ZErUhvfHkabMVu5Xkc0GF6vj5rHBxg2/dbIb8ToG4SpNBWeQCtw/77T9VtDA5u732RLfwTMdvkdDAcI82EgRo6YzwxdNfPwoeS1WiM9LGeb1acy16cL5iAjK/EYpLyoV333E6TJwPq6uAKUpxCuSrKWIY4cKDpiPhB+LBMTKusM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785784663; c=relaxed/simple;
	bh=y/k+8Q4wDIyW40+/grVwIi0R3Z8Do+4QM47y7bGxqwc=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=SodHKdLI64gYSobKqJeuO++AKxmvwdXfPk9Pe4U361Q7wVxldY8Vt16diUtR2YpynoG1p9JHy/WXqt5sc4BojETHoisywychmaXKzxjcVY0yuxvLEQOQCRoIhpNOVhstqC6deadY7SiRVcuSIa2DSTMgo+mPXyEjF3WFCb/jjEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.utexas.edu; spf=pass smtp.mailfrom=cs.utexas.edu; dkim=pass (1024-bit key) header.d=cs.utexas.edu header.i=@cs.utexas.edu header.b=ekjJPyXe; arc=none smtp.client-ip=128.83.139.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cs.utexas.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cs.utexas.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cs.utexas.edu header.i=@cs.utexas.edu header.b="ekjJPyXe"
X-AuthUser: pgoetz
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=cs.utexas.edu;
	s=default; t=1785784510;
	bh=y/k+8Q4wDIyW40+/grVwIi0R3Z8Do+4QM47y7bGxqwc=;
	h=Date:To:From:Subject:From;
	b=ekjJPyXef7iuq3q9F2fhcgfZtwExHNOC58EOMQHklLa6u/KaScNqDwcT5SUeQ4gQY
	 DXLWvpzRxF/l10YQQJwE/aT36D0Y0hEmqn7wxuZlWMLuFU0DaBztfDeYRDbEEw3eGW
	 iPflwCZ1hOnKdE8HtKkQp5kO2U3m8SRpVMJPl/gY=
Received: from [128.83.120.185] (texas-tea.cs.utexas.edu [128.83.120.185])
	(authenticated bits=0)
	by newman.cs.utexas.edu (8.14.4/8.14.4/Debian-4.1ubuntu1.1) with ESMTP id 673JFABq015108
	(version=TLSv1/SSLv3 cipher=AES128-GCM-SHA256 bits=128 verify=NOT)
	for <fio@vger.kernel.org>; Mon, 3 Aug 2026 14:15:10 -0500
Message-ID: <984fc666-48fe-4212-96e7-6740a270d755@cs.utexas.edu>
Date: Mon, 3 Aug 2026 14:15:10 -0500
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
Subject: Consistent core dump of fio 3.36
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.9 (newman.cs.utexas.edu [128.83.139.110]); Mon, 03 Aug 2026 14:15:10 -0500 (CDT)
X-Virus-Scanned: clamav-milter 0.103.8 at newman
X-Virus-Status: Clean

Hi -

Running this command:

# fio --name=filecreate --directory=/data/fio-test \
   --nrfiles=100000 --filesize=4k --rw=write --bs=4k \
   --ioengine=sync --create_on_open=1 \
   --openfiles=128 --numjobs=8 --group_reporting

results in a consistent core dump:

------------------------------------------------
root@labrat:/data/fio-test# fio --name=filecreate 
--directory=/data/fio-test --nrfiles=100000 --filesize=4k --rw=write 
--bs=4k --ioengine=sync --create_on_open=1  --openfiles=128 --numjobs=8 
--group_reporting
filecreate: (g=0): rw=write, bs=(R) 4096B-4096B, (W) 4096B-4096B, (T) 
4096B-4096B, ioengine=sync, iodepth=1
smalloc: OOM. Consider using --alloc-size to increase the shared memory 
available.
smalloc: size = 384, alloc_size = 404, blocks = 13
smalloc: pool 0, free/total blocks 1/524320
smalloc: pool 1, free/total blocks 8/524320
smalloc: pool 2, free/total blocks 10/524320
smalloc: pool 3, free/total blocks 10/524320
smalloc: pool 4, free/total blocks 10/524320
smalloc: pool 5, free/total blocks 10/524320
smalloc: pool 6, free/total blocks 10/524320
smalloc: pool 7, free/total blocks 10/524320
fio: filesetup.c:1746: alloc_new_file: Assertion `0' failed.
Aborted (core dumped)
------------------------------------------------

Is there something wrong with my syntax?

