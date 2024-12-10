MODEL small
code SEGMENT
ASSUME CS:code, DS:code

menu db  '1. CUSTOM DISH', 0Dh, 0Ah, \
         '2. CHICKEN (200C, 120 MIN)', 0Dh, 0Ah, \
         '3. FISH (180C, 90 MIN)', 0Dh, 0Ah, \
         '4. CAKE (175C, 30 MIN)', 0Dh, 0Ah, \
         '5. EXIT', 10, "$" 

error_temp db 10, 13, 'ERROR: INVALID TEMP', 10, 13, "$" 
error_time db 10, 13, 'ERROR: INVALID TIME', 10, 13, "$"                                 
prompt_temp db 'Set Temperature (50-300): $', 0 
prompt_time db 'Set time (0-120): $', 0  
time_input db 4,0,4 dup("$")          
temp_input db 4,0,4 dup("$")  
preset_temp_msg db "Selected temperature: $" 
preset_time_msg db "Selected time: $"
print_number dw 4,0,4 dup("$") 		                 
temp dw 50  
time dw 0

start:
	mov ax, cs
	mov ds, ax
	call print_menu

choose_option:
	mov ah, 08h
	int 21h

    cmp al, "1"
    je CUSTOM_DISH
    cmp al, "2"
    je CHICKEN
    cmp al, "3"
    je FISH
    cmp al, "4"
    je CAKE
    cmp al, "5"
    je sfarsit

	jmp choose_option

CUSTOM_DISH:
	call input_temp
	call input_time
	call show_preset_values
	jmp choose_option

CHICKEN:
	mov temp, 200
	mov time, 120
	call show_preset_values
	jmp choose_option	

FISH:
    mov temp, 180       ; Setează temperatura pentru Preparatul 2
    mov time, 90        ; Setează timpul pentru Preparatul 2
    call show_preset_values
    jmp choose_option

CAKE:
    mov temp, 175       ; Setează temperatura pentru Preparatul 3
    mov time, 30        ; Setează timpul pentru Preparatul 3
    call show_preset_values
    jmp choose_option

sfarsit:
	mov ax, 4c00h
	int 21h

input_temp proc
	mov dx, offset prompt_temp
	mov ah, 09h
	int 21h

	mov ah, 0ah
	lea dx, temp_input
	int 21h
	
	lea si, temp_input + 2
	mov cl, [temp_input] + 1
	mov ax, 0
	mov bx, 0
convert_to_integer:
	mov bl, 10
	mul bx
	mov bl, [si]
	sub bl, "0"
	add ax, bx
	inc si
	loop convert_to_integer

	mov temp, ax
	call check_temperature
	ret
input_temp endp

check_temperature proc
	cmp temp, 50
	jl eroare_temp
	cmp temp, 300
	jg eroare_temp
	ret
check_temperature endp

eroare_temp proc
	mov dx, offset error_temp
	mov ah, 09h
	int 21h
	jmp CUSTOM_DISH
eroare_temp endp

input_time proc
	mov dl, 10
	mov ah, 02h
	int 21h

	mov dx, offset prompt_time
	mov ah, 09h
	int 21h

	mov ah, 0ah
	lea dx, time_input
	int 21h
	
	lea si, time_input + 2
	mov cl, [time_input] + 1
	mov ax, 0
	mov bx, 0
convert_to_integer_time:
	mov bl, 10
	mul bx
	mov bl, [si]
	sub bl, "0"
	add ax, bx
	inc si
	loop convert_to_integer_time

	mov time, ax
	call check_time

	mov dl, 10
	mov ah, 02h
	int 21h
	ret
input_time endp

check_time proc
	cmp time, 0
	jl eroare_time
	cmp time, 120
	jg eroare_time
	ret
check_time endp

eroare_time proc
	mov dx, offset error_time
	mov ah, 09h
	int 21h
	jmp input_time
eroare_time endp

print_menu proc
	mov dx, offset menu
	mov ah, 09h
	int 21h
    ret
print_menu endp

show_preset_values proc
	mov dx, offset preset_temp_msg
	mov ah, 09h
	int 21h

	mov ax, temp
	call printNumber

	mov dl, "C"
	mov ah, 02h
	int 21h

	mov dl, 10
	mov ah, 02h
	int 21h

	mov dx, offset preset_time_msg
	mov ah, 09h
	int 21h

	mov ax, time
	call printNumber

	mov dl, 10
	mov ah, 02h
	int 21h
	int 21h
    ret
show_preset_values endp

printNumber PROC
	mov bx, 10
	mov cx, 0
impartire:
	mov dx, 0
	div bx
	push dx
	inc cx
	cmp ax, 0
	jnz impartire
afisare:
	pop dx
	add dl, "0"
	mov ah, 02h
	int 21h
	loop afisare

	ret
printNumber ENDP


code ENDS
end start
