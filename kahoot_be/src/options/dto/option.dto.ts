import { Expose } from "class-transformer";

export class OptionDto {    
    @Expose()
    question_id: number;

    @Expose()
    option_text: string;

    @Expose()
    is_correct: boolean;

    constructor(partial: Partial<OptionDto>){
        Object.assign(this, partial);
    }
}