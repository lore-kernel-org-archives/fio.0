Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A6E21ABCF
	for <fio@vger.kernel.org>; Mon, 31 Mar 2025 14:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743432114; cv=none; b=LPlOCky7KREmsWYIxiRfKIJ2Rb2lChimIHT5fZDIRW8t77xP5sgZB3Y9sm8nGJL7A2V+Ry2LSOwU+z4fwmE3ry+v9gBVWF6wFtXS/X88n8g6wPMszz3kPFldoyT3ZbcO+lfhCeUFyxp+fNkKSTvc/DH8Y0KLu33IDtYdn/UllHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743432114; c=relaxed/simple;
	bh=otr2ayZzW2P0mU5KBzLXuw/N3uJ01qO4U7aZLrCpz2U=;
	h=Date:Content-Type:MIME-Version:From:To:Subject:In-Reply-To:
	 References:Message-ID; b=aJn4smbiRdezYmKNKFsIns4S4XWmwNg7XAC6uHppyblkcAkQL7hwczh0N2qT0Btu5BZUtPpcTEDn+rPAaPp7hpDjmjynk+5sshYhJ22+GF/byWoxUivApD7DKxAO7h6FdYBIJlJa5YugwC6rAasSFpc+1efe5+vyBbyPhwRuP5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TNmQVyOx; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TNmQVyOx"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4766cb762b6so42062071cf.0
        for <fio@vger.kernel.org>; Mon, 31 Mar 2025 07:41:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743432112; x=1744036912; darn=vger.kernel.org;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=otr2ayZzW2P0mU5KBzLXuw/N3uJ01qO4U7aZLrCpz2U=;
        b=TNmQVyOxK7oH04O1+H8L4QU/NyWMQzHiLNDyRKXVUYvXaexohnzllsVmmJhUk2X189
         AjxnUztld+psQNMgiwU9KZ4lmn9v4T2TOV9C8sjnIXtgGfUGXCwUkjZ9ByrK1p6PRpE1
         VDfumWTG8y42WzSzYiAcjjsEiM8NT/pWaN+5EiJR7T/1qH66ALMFUWlsyw2ZklLFO0XO
         S80IgyNsfmiHRZbopTLCWTePdn+lBy1hmcQS2jpIiEEig3DzDNUJmssOTZVcIc3rNoes
         JR2+oHXFwk3wC7S5erRk7cVqogIRmJfBimnlMnmgF5gWZek+Msv7uBnoFkBeXgWE9mTP
         P9rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743432112; x=1744036912;
        h=message-id:references:in-reply-to:subject:to:from:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=otr2ayZzW2P0mU5KBzLXuw/N3uJ01qO4U7aZLrCpz2U=;
        b=KSDBRyt+2Pmn+RqC6wJ6h4E8hqLK920MyPab7lzzOvezv+TAYa46OZbcisRHm2hThR
         7RDa6oFQMw+lXBVec9GIt7mO0/WW2IyGK+8frcYndNOnDTVcHjDSBiALIiB2OZfbdbX/
         pV1QMe8b3E9dfNjPIHdrvUUAxp1PqgGtMkJgbah6gtj87m1+y+5M8poqC3bnJoP7VE92
         HKmjbNv5ZhXP4V3R/u3r4b41mpOjs6r66hDFbMDsQFX1ZowooGa9wjerywiokGQd6J/2
         0jU8lFtNXrdnxtbdpTXMjCxqmnrLFTrQPRUSHouhaINpw02azzAg1f3HLxERqri83QRv
         lAMQ==
X-Gm-Message-State: AOJu0Yw/CoQ0N/NhvsJsqWNe0BwgChU0V1Zk+EwkJZiXWVp2TVWMd1cu
	hFUuEQGMTXtpHNTU6SaYYAzYFZbdtLbDW0qHykhUs8SF35Z3KnaSm37TmK8=
X-Gm-Gg: ASbGncvHrox6w/2z4ojCVfNWORAceSI8rAshlJo2LO6fdFfKCE2TksqjISwD8h5pH7O
	MH6NspYSCeIvHtdqyKA5GuTeQyi2qDiKDzxXWNc8Nk8M/oa92FbgyTrXyyHO3fj3sd4SPutYaoL
	ucGHKR4DBJ318lExkm0+2+iakbeH/TxYzU+QwA64jBxvB/foVrZYK4OI4q2WJOezEuACE2CSLUE
	7/WG/Z9KSw3YQPJyGPl0pC0BWMVHi+E8bouYlQwrYtw9RUYXAUxDIF03R5O5eb0nGzDO1kq9vYG
	yjiNJn6ZRZEgt3rw190boGImfpAVEPTN4rjgzHqi9Nln07g08RRLhhoW+FWdjcgAQi7OomLpxwm
	35XvivjWr5ACx4e/n1zPppRNWEOIgdd+cmO9iCw==
X-Google-Smtp-Source: AGHT+IHGz3Qsek7l0h9zzFHA0V++GRkZQyysY2+Yian40zfoVQYzwCjpUQPgSUUduwLxkomd73S15A==
X-Received: by 2002:a05:622a:5a1a:b0:472:521:871a with SMTP id d75a77b69052e-477845e5eb0mr210465541cf.23.1743432111905;
        Mon, 31 Mar 2025 07:41:51 -0700 (PDT)
Received: from fv-az1964-598.n50j0q0wg3ueflgghgs2zwx0ph.bx.internal.cloudapp.net ([20.42.49.182])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-47782a7fab5sm50755391cf.36.2025.03.31.07.41.51
        for <fio@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Mar 2025 07:41:51 -0700 (PDT)
Date: Mon, 31 Mar 2025 07:41:51 -0700 (PDT)
Content-Type: multipart/mixed; boundary="===============0582896714574266319=="
Precedence: bulk
X-Mailing-List: fio@vger.kernel.org
List-Id: <fio.vger.kernel.org>
List-Subscribe: <mailto:fio+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:fio+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: fiotestbot@gmail.com
To: fio@vger.kernel.org
Subject: =?utf-8?q?Re=3A_=5BPATCH_0/7=5D_verify_trim_operations?=
In-Reply-To: <20250331140204.1971-1-vincent.fu@samsung.com>
References: <20250331140204.1971-1-vincent.fu@samsung.com>
Message-ID: <174343211141.2487.6017345249818370842@fv-az1964-598.n50j0q0wg3ueflgghgs2zwx0ph.bx.internal.cloudapp.net>

--===============0582896714574266319==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit


The result of fio's continuous integration tests was: failure

For more details see https://github.com/fiotestbot/fio/actions/runs/14173747734

--===============0582896714574266319==--
