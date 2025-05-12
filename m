Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E0C2517A5
	for <fio@vger.kernel.org>; Mon, 12 May 2025 16:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747067608; cv=none; b=XC1jZcQGZakKkC32du5EXV5F0x0CM6MI/8MyHoM2NeENGzoJyvt1xzmJ9E+9OsM+XyLoABq0B/8nj6v4KxBJgltIDhCOABdw0Odn6Ph0rVIY/1YZRLQht3CefJ3eOTeYCVwqD6adJVk6wlXQfV7kZ9SB5fHfx4RtAIX5Mjh95S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747067608; c=relaxed/simple;
	bh=OJE5Yi8wFJEKSfC1RGEhlGQQRX5QSAxtPfm3/T2pmyc=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=abMJeEYxA7ss5QeklIqm3769VcVn3TbE8urZ04J3GIAOAnH9lIkQi2nxkYZa4fiOGoJC/dS3+dOms9jytWembM7Bw1zz6nNzxprnFwZdMii5EOK3LyAuICoxitYu3PYXkQSFnX3DlGU37U+Bxo9o0C7ZSUgUOD41umqXAZFZhSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VQcWI47w; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VQcWI47w"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-7c5e2fe5f17so530270285a.3
        for <fio@vger.kernel.org>; Mon, 12 May 2025 09:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747067606; x=1747672406; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S7fUR9M7kuOjrJI6l+E0mxcpgeVAT9jG0d/bbYnikaM=;
        b=VQcWI47wQ0DJKEAWhnO43nAwBAd3j4bN6o3iUT3xVxssohz3RbdyVzGin/GffSAPNN
         7iugt9pRyhlYgUHLwok0TcA0LXWCP9yKmD1Ze808AD9pWCflsYEIm7BXsbHWytz+oP6l
         S43kp5DuXhPUBAOnDmfVXCxz75wIQeQj54fG7wo6TUDhd3Uu8nDeakt0qBKgKOdRbUNf
         9/toPGWfxpF/8GTWCsv/IvYUb4OpQBoIzgvDkog5Qc6UtUFoFeUxlkYXrGH7tNLW2En0
         Z0IYGbiZKJV5n/HX5+QhDOnZb9vTr2E6lK1ZwXvFfcBAZOWV2QPP88PyLuTuWiCJ4CxT
         xuag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747067606; x=1747672406;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S7fUR9M7kuOjrJI6l+E0mxcpgeVAT9jG0d/bbYnikaM=;
        b=rHpoo/GGGbW1LR2+gcyGIfneo0wf/CN1XlRy9eLioh9uSb7ihY80hdFzqe8K1XxfcE
         plk41nLz4lQj8EbV1eWlIi7TRfdp6Iwql771C/A1ezhW5wTA+isqwasBsF+2+sIIB//y
         SRfWBXs85lr5TNp8Gjy0UcDFz+zG/dncb+iUd2434KqiakW82ctZzteKbfj0whBhXX48
         dsrVKV01mgy3VrJsYyTqH2zEofC7CAGk/47ol1kiS6iBvp2rXZCDvc5w1Dpz6VrEO9Uf
         C0E396UGXZ6einfhA+2QMsfOQSucOJ5D48djXpc3zD27PKjuBX3TrSJaf3Vu9EugDdXZ
         JHnA==
X-Gm-Message-State: AOJu0YxzBTRBIIVYa6hVNno8Nurr237pBUXysb4+ls6OWNZ9LCX1pEx4
	v5KWu2pl0fq3biisknppyUM+oyF2W0cdId5l6XtXA+38lbeMXrgr4klv
X-Gm-Gg: ASbGnctbu4eEPjKiW0HHW7oa8sUxt8RgUMsU0ts7fRjSm3xzQVeCQ77X80ZLEQvQXJA
	uAqfleo7Rj/FkE4s14M9Uaa4hvEoYdWl18joDIsiC7ID1/Ar++bJLbSj1e8M6O0NLsOE6oPjpHd
	l3Ji6L8PCypsjoJO8X8UeeFCPUnMGrup0THsQe652uOBR3JiUJbmVDdovcRNVT8OYhMj1RaQSzq
	4W3vfDvs7H/GxfH9+HP5JT/a5V6k9TlUUv7BA8+1NMHYICk5nLMrt73cB74ZkHbqCyKn2n9C2L5
	nycGp5zIG7d6Lqb/UzAXYOjZ1YV7ZHkI0o+69Xb0Cpaev310b9nJmWS/AiKqJ4+VT8BkKxG3bL8
	LiN5rjPwpjLd+1HVzwwEt+gVtGic=
X-Google-Smtp-Source: AGHT+IGXcF2syuXnn6RfjVFdXcJ/zhok4wAEK6dLNC+puSoJ0p1RX/t+eVzUN23i7HoeS7myCgZDXw==
X-Received: by 2002:a05:620a:2695:b0:7c5:f696:f8e5 with SMTP id af79cd13be357-7cd01103f44mr2670086685a.14.1747067605556;
        Mon, 12 May 2025 09:33:25 -0700 (PDT)
Received: from [192.168.1.211] (pool-173-79-40-147.washdc.fios.verizon.net. [173.79.40.147])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7cd00f4d581sm571031585a.7.2025.05.12.09.33.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 May 2025 09:33:25 -0700 (PDT)
Message-ID: <a3f156e6-feee-4194-9774-735674b8ef30@gmail.com>
Date: Mon, 12 May 2025 12:33:24 -0400
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fio_sem, diskutil: introduce fio_shared_sem and use it
 for diskutil lock
From: Fio Test Bot <fiotestbot@gmail.com>
To: fio@vger.kernel.org, Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
References: <20250512013022.64633-1-shinichiro.kawasaki@wdc.com>
 <174703965379.2555.752018432508173249@fv-az1693-421.ta2el201fmauvbt1524me5x4xb.dx.internal.cloudapp.net>
Content-Language: en-US
In-Reply-To: <174703965379.2555.752018432508173249@fv-az1693-421.ta2el201fmauvbt1524me5x4xb.dx.internal.cloudapp.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/12/25 4:47 AM, fiotestbot@gmail.com wrote:
> 
> The result of fio's continuous integration tests was: cancelled
> 
> For more details see https://github.com/fiotestbot/fio/actions/runs/14962653715

This test failed because of a longstanding issue with t0013.fio. I 
re-ran the test and the second try passed.

Vincent
