Return-Path: <sitsofe@gmail.com>
MIME-Version: 1.0
References: <20201116030321.1957-1-rebecca@bsdio.com>
In-Reply-To: <20201116030321.1957-1-rebecca@bsdio.com>
From: Sitsofe Wheeler <sitsofe@gmail.com>
Date: Sun, 22 Nov 2020 15:05:31 +0000
Message-ID: <CALjAwxgjD6_iEMVTd0W-HxYfkBNj8Br183P3aqo=f+TLu-T=Kw@mail.gmail.com>
Subject: Re: [PATCH] Windows: introduce fiobuild.cmd and fiopkg.cmd
Content-Type: text/plain; charset="UTF-8"
To: Rebecca Cran <rebecca@bsdio.com>
Cc: fio <fio@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
List-ID: <fio@vger.kernel.org>

Some minor comments otherwise looks good!

On Mon, 16 Nov 2020 at 03:03, Rebecca Cran <rebecca@bsdio.com> wrote:
>
> fiobuild.cmd automates the building process to pass the correct arguments
> to configure to build fio for use on any x86 or x64 processor by using
> --disable-native.
>
> fiopkg.cmd optionally signs the binaries, builds the installer and signs
> that too.
>
> dobuild.cmd was misnamed, but is now used by CI. Keep it around, but
> update it to just call fiopkg.cmd.
>
> Signed-off-by: Rebecca Cran <rebecca@bsdio.com>
> ---
>  os/windows/_domake.sh   | 17 +++++++++++++
>  os/windows/dobuild.cmd  | 53 +----------------------------------------
>  os/windows/fiobuild.cmd | 17 +++++++++++++
>  os/windows/fiopkg.cmd   | 52 ++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 87 insertions(+), 52 deletions(-)
>  create mode 100755 os/windows/_domake.sh
>  create mode 100644 os/windows/fiobuild.cmd
>  create mode 100644 os/windows/fiopkg.cmd
>
> diff --git a/os/windows/_domake.sh b/os/windows/_domake.sh
> new file mode 100755
> index 00000000..05625ff4
> --- /dev/null
> +++ b/os/windows/_domake.sh
> @@ -0,0 +1,17 @@
> +#!/usr/bin/env bash

We use /bin/bash everywhere else so I think we should do so here for
consistency.

<snip>

> diff --git a/os/windows/fiobuild.cmd b/os/windows/fiobuild.cmd
> new file mode 100644
> index 00000000..4a4171a2
> --- /dev/null
> +++ b/os/windows/fiobuild.cmd
> @@ -0,0 +1,17 @@
> +@echo off
> +setlocal enabledelayedexpansion
> +
> +if "%1"=="x86" set FIO_ARCH=x86
> +if "%1"=="x64" set FIO_ARCH=x64
> +
> +if not defined FIO_ARCH (
> +  echo Error: must specify the architecture.
> +  echo Usage: fiobuild x86
> +  echo Usage: fiobuild x64
> +  goto end
> +)
> +
> +C:\Cygwin64\bin\bash -l %cd%/_domake.sh %FIO_ARCH% %cd%

Could you just call bash so you work in msys2 environments too?

> +
> +
> +:end
> \ No newline at end of file
> diff --git a/os/windows/fiopkg.cmd b/os/windows/fiopkg.cmd
> new file mode 100644
> index 00000000..08df3e87
> --- /dev/null
> +++ b/os/windows/fiopkg.cmd
> @@ -0,0 +1,52 @@
> +@echo off
> +setlocal enabledelayedexpansion
> +set /a counter=1
> +for /f "tokens=3" %%i in (..\..\FIO-VERSION-FILE) do (
> + if "!counter!"=="1" set FIO_VERSION=%%i
> + set /a counter+=1
> +)
> +
> +for /f "tokens=2 delims=-" %%i in ("%FIO_VERSION%") do (
> + set FIO_VERSION_NUMBERS=%%i
> +)
> +
> +if not defined FIO_VERSION_NUMBERS (
> +  echo Could not find version numbers in the string '%FIO_VERSION%'
> +  echo Expected version to follow format 'fio-^([0-9]+.[0-9.]+^)'
> +  goto end
> +)
> +
> +if "%1"=="x86" set FIO_ARCH=x86
> +if "%1"=="x64" set FIO_ARCH=x64
> +
> +if not defined FIO_ARCH (
> +  echo Error: must specify the architecture.
> +  echo Usage: dobuild x86
> +  echo Usage: dobuild x64
> +  goto end
> +)
> +
> +if defined SIGN_FIO (
> +  signtool sign /n "%SIGNING_CN%" /t http://timestamp.digicert.com ..\..\fio.exe
> +  signtool sign /as /n "%SIGNING_CN%" /tr http://timestamp.digicert.com /td sha256 /fd sha256 ..\..\fio.exe
> +
> +  signtool sign /n "%SIGNING_CN%" /t http://timestamp.digicert.com ..\..\t\*.exe
> +  signtool sign /as /n "%SIGNING_CN%" /tr http://timestamp.digicert.com /td sha256 /fd sha256 ..\..\t\*.exe
> +)
> +
> +if exist ..\..\fio.pdb (
> +  set FIO_PDB=true
> +) else (
> +  set FIO_PDB=false
> +)
> +
> +"%WIX%bin\candle" -nologo -arch %FIO_ARCH% -dFioVersionNumbers="%FIO_VERSION_NUMBERS%" -dFioPDB="%FIO_PDB%" install.wxs
> +@if ERRORLEVEL 1 goto end
> +"%WIX%bin\candle" -nologo -arch %FIO_ARCH% examples.wxs
> +@if ERRORLEVEL 1 goto end
> +"%WIX%bin\light" -nologo -sice:ICE61 install.wixobj examples.wixobj -ext WixUIExtension -out %FIO_VERSION%-%FIO_ARCH%.msi
> +:end
> +
> +if defined SIGN_FIO (
> +  signtool sign /n "%SIGNING_CN%" /tr http://timestamp.digicert.com /td sha256 /fd sha256 %FIO_VERSION%-%FIO_ARCH%.msi
> +)

Will it try to sign even if there was a packaging error?

> --
> 2.29.2
>
>


-- 
Sitsofe | http://sucs.org/~sits/

