@ECHO OFF
setlocal enabledelayedexpansion
:HOME

REM ���û���
set "right_device=Model_code"

set "PATH=%PATH%;%cd%\bin\windows"
set sg=1^>nul 2^>nul

for /f "tokens=2 delims=:" %%a in ('chcp') do set "locale=%%a"

cls

if "!locale!"==" 936" (
    set "confirm_switch={08}{\n}��ȷ��Ҫִ�����������{\n}{\n}���ȷ���������� 'sure'�����������������˳���{\n}{\n}"
    set "device_mismatch_msg=�� ROM ������ !right_device! ��������豸�� !DeviceCode!"
    set "disabled_avb_verification=�ѽ��� Avb2.0 У��"
    set "exit_program={04}{\n}[4] {01}�˳�����{#}{#}{\n}"
    set "execution_completed=ִ����ɣ��ȴ��Զ�����"
    set "failure_status=��ΪĳЩԭ��δ��ˢ��"
    set "fastboot_mode={06}��ǰ����״̬��Fastboot ģʽ{\n}"
    set "fastbootd_mode={06}��ǰ����״̬��Fastbootd ģʽ{\n}"
    set "format_data_flash={04}{\n}[2] {01}��ʽ���û����ݲ�ˢ��{#}{#}{\n}"
    set "formatting_data=���ڸ�ʽ�� DATA"
    set "keep_data_flash={04}{\n}[1] {01}����ȫ�����ݲ�ˢ��{#}{#}{\n}"
    set "kept_data_reboot=�ѱ���ȫ�����ݣ�׼��������"
    set "one_title={F9}            Powered By {F0}Garden Of Joy            {#}{#}{\n}"
    set "retry_message=����..."
    set "select_project={02}��ѡ����Ҫ��������Ŀ��{\n}{\n}"
    set "success_status=ˢ��ɹ�"
    set "switch_to_fastboot={04}{\n}[3] {01}�л��� Fastboot ģʽ{#}{#}{\n}"
    set "switch_to_fastbootd={04}{\n}[3] {01}�л��� Fastbootd ģʽ{#}{#}{\n}"
    set "title=������ UY ��ˢ����"
    set "waiting_device={0D}��������  ���ڵȴ��豸  ��������{#}{\n}{\n}"
) else (
    set "confirm_switch={08}{\n}Are you sure you want to perform this operation?{\n}{\n}If sure, please enter 'sure', otherwise, enter anything to exit��{\n}{\n}"
    set "device_mismatch_msg=This ROM is only compatible with !right_device! , but your device is !DeviceCode!"
    set "disabled_avb_verification=Avb2.0 verification has been disabled"
    set "exit_program={04}{\n}[4] {01}Exit program{#}{#}{\n}"
    set "execution_completed=Execution completed, waiting for automatic reboot"
    set "failure_status=Flash failed"
    set "fastboot_mode={06}Current status: Fastboot mode{\n}"
    set "fastbootd_mode={06}Current status: Fastbootd mode{\n}"
    set "format_data_flash={04}{\n}[2] {01}Format user data and flash{#}{#}{\n}"
    set "formatting_data=Formatting DATA"
    set "keep_data_flash={04}{\n}[1] {01}Keep all data and flash{#}{#}{\n}"
    set "kept_data_reboot=All data has been kept, ready to reboot!"
    set "one_title={F9}            Powered By {F0}Garden Of Joy            {#}{#}{\n}"
    set "retry_message=Retry..."
    set "select_project={02}Please select the project you want to operate��{\n}{\n}"
    set "success_status=Flash successful"
    set "switch_to_fastboot={04}{\n}[3] {01}Switch to Fastboot mode{#}{#}{\n}"
    set "switch_to_fastbootd={04}{\n}[3] {01}Switch to Fastbootd mode{#}{#}{\n}"
    set "title=UY Scuti Flash Tool"
    set "waiting_device={0D}��������  Waiting for device  ��������{#}{\n}{\n}"
)

title !title!

REM ��ʾ�ȴ��豸����Ϣ
echo.
cho !waiting_device!

REM ��ȡ�豸�ͺ�
for /f "tokens=2" %%a in ('fastboot getvar product 2^>^&1^|find "product"') do (
    set DeviceCode=%%a
)
REM ��ȡ�豸�ķ�������
for /f "tokens=2" %%a in ('fastboot getvar slot-count 2^>^&1^|find "slot-count" ') do (
    set DynamicPartitionType=%%a
)
REM �����豸�ķ����������ñ��� DynamicPartitionType ��ֵ
if "!DynamicPartitionType!" == "2" (
    set DynamicPartitionType=NonOnlyA
) else (
    set DynamicPartitionType=OnlyA
)
REM ��ȡ�豸�� Fastboot ״̬
for /f "tokens=2" %%a in ('fastboot getvar is-userspace 2^>^&1^|find "is-userspace"') do (
    set FastbootState=%%a
)
REM �����豸�� Fastboot ״̬���ñ��� FastbootState ��ֵ
if "!FastbootState!" == "yes" (
    set FastbootState=!fastbootd_mode!
) else (
    set FastbootState=!fastboot_mode!
)

cls

echo.
if not "!DeviceCode!"=="!right_device!" (
    cho !device_mismatch_msg!
    PAUSE
    GOTO :EOF
)

cls

cho {F9}                                                {\n}
cho !one_title!
cho {F9}                                                {\n}{\n}
cho !FastbootState!
cho !keep_data_flash!
cho !format_data_flash!
if "!FastbootState!" == "!fastbootd_mode!" (
    cho !switch_to_fastboot!
) else (
    cho !switch_to_fastbootd!
)
cho !exit_program!
echo.

cho !select_project!
set /p UserChoice=
if "!UserChoice!" == "1" (
    set SelectedOption=1
    goto FLASH
) else if "!UserChoice!" == "2" (
    set SelectedOption=2
    goto FLASH
) else if "!UserChoice!" == "3" (
    cho !confirm_switch!
    set /p Confirmation=
    if /I "!Confirmation!" == "sure" (
        if "!FastbootState!" == "!fastbootd_mode!" (
            cls
            echo.
            fastboot reboot bootloader
        ) else (
            cls
            echo.
            fastboot reboot fastboot
        )
    )
    goto HOME
) else if "!UserChoice!" == "4" (
    exit
)
goto HOME&pause

:FLASH
cls 
echo.

REM �� vbmeta �����ļ�ר��ˢ��
set "count=0"
for /R "images\" %%i in (*.img) do (
	echo %%~ni | findstr /B "vbmeta" >nul && (
		if "!DynamicPartitionType!"=="OnlyA" (
			fastboot --disable-verity --disable-verification flash "%%~ni" "%%i"
		) else (
			fastboot --disable-verity --disable-verification flash "%%~ni_a" "%%i"
			fastboot --disable-verity --disable-verification flash "%%~ni_b" "%%i"
		)
		set /a "count+=1"
	)
)
if !count! gtr 0 (
	echo !disabled_avb_verification!
	echo.
)

REM ���������ļ���ˢ��
for /f "delims=" %%b in ('dir /b images\*.img ^| findstr /v /i "super.img" ^| findstr /v /i "preloader_raw.img" ^| findstr /v /i "cust.img" ^| findstr /v /i "recovery.img" ^| findstr /v /i /b "vbmeta"') do (
    set "filename=%%~nb"
    if "!DynamicPartitionType!"=="OnlyA" (
        fastboot flash "%%~nb" "images\%%~nxb"
        if "!errorlevel!"=="0" (
            echo !filename!: !success_status!
            echo.
        ) else (
            echo !filename!: !failure_status!
            echo.
        )
    ) else (
        fastboot flash "%%~nb_a" "images\%%~nxb"
        if "!errorlevel!"=="0" (
            echo !filename!_a: !success_status!
        ) else (
            echo !filename!_a: !failure_status!
        )
        fastboot flash "%%~nb_b" "images\%%~nxb"
        if "!errorlevel!"=="0" (
            echo !filename!_b: !success_status!
            echo.
        ) else (
            echo !filename!_b: !failure_status!
            echo.
        )
    )
)

REM MTK ����ר��
if exist "images\preloader_raw.img" (
    fastboot flash preloader_a "images\preloader_raw.img"
    fastboot flash preloader_b "images\preloader_raw.img"
    fastboot flash preloader1 "images\preloader_raw.img"
    fastboot flash preloader2 "images\preloader_raw.img"
    echo.
)

if exist images\cust.img (
    fastboot flash cust "images\cust.img"
    echo.
)

if exist images\super.img (
    fastboot flash super "images\super.img"
    echo.
)

if "!SelectedOption!" == "1" (
    echo !kept_data_reboot!
) else if "!SelectedOption!" == "2" (
    echo !formatting_data!
    fastboot erase userdata
    fastboot erase metadata
)

if "!DynamicPartitionType!" == "NonOnlyA" (
    fastboot set_active a %sg%
)

fastboot reboot
echo.
echo !execution_completed!
pause
exit
