Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616695FB8F
	for <fio@vger.kernel.org>; Tue, 13 Feb 2024 19:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707852036; cv=none; b=l+etsLK6escNVtUUXF6atFec7vHA7flS18ZAHW2Jv5+IhIyAwfsMgreH2BRfAAHQ/Jn2HzBM2gtQf6ZdqJNE7PUV6F0ntFglu2Rh9TDh7vbenZ4F28cx7UYLk4mqLMFxYzEFlVoqt5WTHJPq8KaBT+Dr/F8EOnjGZdxcMOWSl5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707852036; c=relaxed/simple;
	bh=zLgw5JQsQqjBmzIMGwtsn1OvLxQNgsWUNfYAi5Np9Wo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ieYjbeYz9+muRvpQ9R3pYBHIFxTGwR0xBKwrlxC/rA5IG5zmVKQe/XUkW/WYO76QH65VvwNkkjQggoOhnYtPi5ICO/wnW56nrt9nIeogVTn3d6QoVhKTuhnmoj11lC2WQnZMmVzfR7nkilNAEj7TtstiWzb8VlyDQfzd0MxFsHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Qo/4M9qj; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qo/4M9qj"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-68ce2fe86e3so5430206d6.3
        for <fio@vger.kernel.org>; Tue, 13 Feb 2024 11:20:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707852033; x=1708456833; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IIZuD3xex4gxzWFWMLoafnKqP8mZWWVq4QTvqJwrN1E=;
        b=Qo/4M9qjfbaJWzgNUuX5og2QuS9xJ9xMUsoV6vchE5+BA48iITee8EvmsychYhnJL3
         WZE2uAEwXjLd2VOASK7DZyA6KUKPKynx2suffSx9U+DAQ95yU/Yl4bAtUYAbmUsqcy/+
         n+fHAiyvzhSUi56gw1aKM9pD69PS9wxk3GcIWAUn6JvGhgJojRrx+q6UmCCIgX6MEJGj
         VwLR2Q8ZmzsZVOETrnbCmhfJpBvCUlgmiLNBKd1n7uIs7C0dE+OB1F83byPVoS0iLonI
         G2AH4r5y9v8n53VCZ/x9iZ0X6DhukuDCjtEoQrVhqmbd80o4pTNcyf5RUj429t5p9e8Z
         z7Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707852033; x=1708456833;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IIZuD3xex4gxzWFWMLoafnKqP8mZWWVq4QTvqJwrN1E=;
        b=maDAfemqD7npR2kDF1ePcMX//Gi9H0ZXKrHBDuLWjSarkwQZXigZ6Id8hlrcVdsMeX
         Fpcgy3fGFrefsDS+WokAtyp0B/x+5/EAXIi+yXgxuH7AnSp9R6KGFD1SRt2Ba4CpJoVE
         SFqhCa78a/jv0w2nSguFk7iMdjnoL2i42KiYaOY3PFCVDpt7fJVZJisczNW7SlCymapz
         8gaayYVmjkWpWHd2zJzU9BE51x96hzkEc10han14WxyeR4Y2LHFDpI5pWslJaHoYe1Ie
         ELMIc75JWoMagg3tHvlkdqIKG10TgKeMMR5khtLD89PmowwyHUd2k8lCo4naApjmFeF0
         O+Qw==
X-Gm-Message-State: AOJu0YwMOqQft9qKOq+Vvrj37fS5wTUBK7HmtpZ+kRmsoKb65I82xtPn
	zKX8A7dFjrN7j+XYBDbojrdUelP0DVNUAgR4iPDHvcg+4nxETZ6y
X-Google-Smtp-Source: AGHT+IFv/c1jxjElp+XsrihvmxVXIg8j2OrW8FtwCN/XXyEKfL94OXOHC5C+V9/X6HhD7HLFQo/DWA==
X-Received: by 2002:a0c:dd8a:0:b0:68e:e9ae:c44f with SMTP id v10-20020a0cdd8a000000b0068ee9aec44fmr395694qvk.23.1707852032993;
        Tue, 13 Feb 2024 11:20:32 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXmM/RzrhwHG42CTvvc550uF+VvjOVlBF3ivDpQRwEaXe7meNmAxewd3ZHYtEkWpemT5J5k2YRer19XaqXuppIc3fQTU/nqF88rXwBvDnVhbbSJf7M=
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id ly10-20020a0562145c0a00b0068d1cc639besm1477536qvb.124.2024.02.13.11.20.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Feb 2024 11:20:32 -0800 (PST)
Message-ID: <ad292863-b1d3-41d1-8c47-4eaadfda3591@gmail.com>
Date: Tue, 13 Feb 2024 14:20:32 -0500
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] engines/xnvme: add checks for verify, block size and
 metadata size
Content-Language: en-US
To: Ankit Kumar <ankit.kumar@samsung.com>, axboe@kernel.dk
Cc: fio@vger.kernel.org
References: <20240213153315.134202-1-ankit.kumar@samsung.com>
 <CGME20240213101606epcas5p34f9948ca837dcb8a2413ede602a7e39c@epcas5p3.samsung.com>
 <20240213153315.134202-5-ankit.kumar@samsung.com>
From: Vincent Fu <vincentfu@gmail.com>
In-Reply-To: <20240213153315.134202-5-ankit.kumar@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/13/24 10:33, Ankit Kumar wrote:
> Add checks to ensure that the correct block size and metadata size is
> passed by the user.
> Disable normal verify checks when end to end data protection checks
> are enabled because of CRC conflict.
> 
> Signed-off-by: Ankit Kumar <ankit.kumar@samsung.com>
> ---
>   engines/xnvme.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 49 insertions(+)
> 
> diff --git a/engines/xnvme.c b/engines/xnvme.c
> index c726b805..a8137286 100644
> --- a/engines/xnvme.c
> +++ b/engines/xnvme.c
> @@ -11,6 +11,7 @@
>   #include <assert.h>
>   #include <libxnvme.h>
>   #include "fio.h"
> +#include "verify.h"
>   #include "zbd_types.h"
>   #include "fdp.h"
>   #include "optgroup.h"
> @@ -345,6 +346,49 @@ static void xnvme_fioe_cleanup(struct thread_data *td)
>   	td->io_ops_data = NULL;
>   }
>   
> +static int _verify_options(struct thread_data *td, struct fio_file *f,
> +			   struct xnvme_fioe_fwrap *fwrap)
> +{
> +	struct xnvme_fioe_options *o = td->eo;
> +	unsigned int correct_md_size;
> +
> +	for_each_rw_ddir(ddir) {
> +		if (td->o.min_bs[ddir] % fwrap->lba_nbytes || td->o.max_bs[ddir] % fwrap->lba_nbytes) {

I thought this was wrong at first but I tried it on a device formatted 
in extended LBA mode (4096+64) and indeed lba_nbytes was 4160. I also 
checked the xNVMe source code and found where this can be set to be the 
sum of the LBA data and metadata sizes. It would be helpful to improve 
the xNVMe documentaion to make explicit what this value is.

Vincent
