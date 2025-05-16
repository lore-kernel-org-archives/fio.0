Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8538127AC54
	for <fio@vger.kernel.org>; Fri, 16 May 2025 18:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747418909; cv=none; b=JiavnZvCmfJb+ObyJeXAZKGu9ohrliRs/tVzMZdT7xgInFhq+8M0Cu6AwIXmp90/ofNhAlAzv9gzLnsk/Ag3pEmIdvnk/lsh6i95wP/7JvsyzyNmSXBbesBBAA0Gp+3mOxxsC1zGzlWrDbfSPiAG2JTKIr3+t+I6T8R0J/ZvO8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747418909; c=relaxed/simple;
	bh=BbeSXMDolaHZ2QfL9HvlePKjekQaLR+FJJ1PHCJdSNE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=Lwk4uWJadsQVa+AXq4Bb8tZgYcI5nTzBAsHIn6Rt0JHtqD/oWkvXq9hkfNQUjwbzfR3C7zXHMx2UIqnhkl9Xy2oIlwL1Ywbeask+U81TV99/PHJP7Oyzf/GWF04Ec1wCnA3EJkwVXuTX0v7MKq2K0lM2+/Wt4nC6h6p2oNVmi8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XcEUT2g4; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XcEUT2g4"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-7c56a3def84so227441785a.0
        for <fio@vger.kernel.org>; Fri, 16 May 2025 11:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747418906; x=1748023706; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nPGr3qs6Jhvf5dbmnuBZdPKXbX5hASjl0rjnbgQK2u4=;
        b=XcEUT2g47fd2QdRvLu+Zf6pRbVcNN8dMZsHxsT166KYww7r6oO/QZPpa5XBCSKuYyC
         Nbi7KT3u+k3NMxJTq6HuNT+LRtAq36/4WbZGyT1ReDJoEtNnxBnzCsRlmfoWXxABPj4N
         P5P52kQS+NPaWja8pkJbtiWhLF5cZxz6RK6gox4Vrtu1H5AK2udQEpOLSH09sto4asu1
         3cEd0Iqu2zLCBQcr1VRta/kOimRm9PREO/QCe2HRG5P8vsXkKpYR+EUExTiOxXwYp66H
         8XVGSjdQiDPcTsjHvZe++YhsQAO4oV7NXfQa1GcYBo58mKJ2r3xYHdjIqwVEk7/PsWPe
         cnUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747418906; x=1748023706;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nPGr3qs6Jhvf5dbmnuBZdPKXbX5hASjl0rjnbgQK2u4=;
        b=hUR6C5SbakDVIkG6o2OrUZW+Mdui/O/B+w0MLeVHOxCoITCCErEd5Goz+snk1TGx6h
         jb6IfCT4KnMVZSsJk5BQnoI79AYqNkQxc6hu2Bv+1qUo62tDUBOMWyJbYBPtbDZD4O89
         mzfGmMzKAWy1JRBZ5T+0gp4LitMaE4O8APK8r6m8khL5/5XwQh2hRP7dUGqrvZM0BzhZ
         V9bCtUabcsCCoQnNxhPcNMAU7hJ4toeYfWfI894GdOAPUHgh4XCtSOV099LyqYGqDH6b
         CkMFzw181FO4msDbqJ8xDLbV/BKNfaZfaZjQNE1iTMZsZRgg5uvTU+MKB2GZXTVzXscn
         oH1Q==
X-Gm-Message-State: AOJu0YxL+R8ldy0E1/nXZYRhh+nAgNUnykzc4gCBDxmC/W4S6VAMZz/R
	0ubtvC2VPt4B2Xtnvo7FX7lEtxFvnQN+q2F0C7HuYbYcbN1bOVdDq9SXuIoh
X-Gm-Gg: ASbGncv5LEHJd+YSxWeyhE5U+jF5Z4us2C+t+cnqwMj7/cjMESl7DIK0LijTxfTqqYe
	wD+L3bcaeoH8hiNkOsM469Pd9Itn6AoxNHdlEsKDtPvYK6pKwUjmfMaMnC/0AF29teo187/o98f
	AorusmLHIgEGSib+mBDt153P/PcysI/vOg/gaNIzc+92TR7dF1BMGf6GHHV0wVdaAZmxrIEYNcz
	kYKolhuBFHm8jMolQRBKwdy1FE81Zc4RKVEyJZP+C30uRK6hGMGWU09IOcH7jEqH+JNr5a5PLTD
	R5zWVXkmMY4TDjV2MPlSuO/mIb4dvXK9Ph1d7nrxxzPvXL7sbRkg4Cdq6FXmiCP1cVSThXfWarQ
	AuNYPPj9bns21Zs2BN4vC1mNe8yM=
X-Google-Smtp-Source: AGHT+IEnzGPfdW5XMIwSalw6WjpLgMNDr9nRqC0crtdy4JYKsJdFWag/sz+veM4AW2FfC1SM5qEJbw==
X-Received: by 2002:a05:620a:290e:b0:7c5:4278:d15f with SMTP id af79cd13be357-7cd46724cc8mr576340985a.17.1747418905800;
        Fri, 16 May 2025 11:08:25 -0700 (PDT)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6f8b097b5c2sm14800006d6.112.2025.05.16.11.08.25
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 May 2025 11:08:25 -0700 (PDT)
Message-ID: <8027f1ef-ef60-4393-8a22-f5b86fb85a45@gmail.com>
Date: Fri, 16 May 2025 14:08:25 -0400
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/11] verify pattern interval
From: Fio Test Bot <fiotestbot@gmail.com>
To: fio@vger.kernel.org
References: <20250508185832.3702-1-vincent.fu@samsung.com>
 <174673377441.2581.14259152939735507019@fv-az1694-607>
 <41222b13-43d1-4d5a-8803-66fbd265e575@gmail.com>
Content-Language: en-US
In-Reply-To: <41222b13-43d1-4d5a-8803-66fbd265e575@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/8/25 8:54 PM, Fio Test Bot wrote:
> On 5/8/25 3:49 PM, fiotestbot@gmail.com wrote:
>>
>> The result of fio's continuous integration tests was: failure
>>
>> For more details see https://github.com/fiotestbot/fio/actions/ 
>> runs/14914258938
> 
> Hoisted by my own petard.
> 
> There was one test failure with t/jobs/t0010:
> 
> https://github.com/axboe/fio/blob/master/t/jobs/t0010-b7aae4ba.fio
> 
> This job is a simple io_submit_mode=offload test:
> 
> # Expected result: fio runs and completes the job
> # Buggy result: fio segfaults
> #
> [test]
> ioengine=null
> size=10g
> io_submit_mode=offload
> iodepth=16
> 
> My changes do not touch this code. I looked at Actions runs in the main 
> repository and found no similar failures in the 90 days of available 
> logs. I did find two failures in Actions logs on my fork:
> 
> https://github.com/vincentkfu/fio/actions/runs/14414832872/job/40429681779
> 
> https://github.com/vincentkfu/fio/actions/runs/13680647374/job/38251879040
> 
> I re-ran the test suite on the failed platform for my patch series and 
> it passed:
> 
> https://github.com/fiotestbot/fio/actions/runs/14914258938
> 
> So I am comfortable that my patches are not responsible for this failure.
> 
> Vincent
> 

I have committed these patches.

Vincent
