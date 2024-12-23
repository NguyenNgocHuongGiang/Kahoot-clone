import { Expose } from "class-transformer";

export class QuestionDto {    
    @Expose()
    quiz_id: number;
    
    @Expose()
    question_text: string;

    @Expose()
    question_type: 'multiple_choice' | 'true_false' | 'open_ended' | 'puzzle' | 'poll';

    @Expose()
    media_url?: string;

    @Expose()
    time_limit?: number;

    @Expose()
    points?: number;

    constructor(partial: Partial<QuestionDto>){
        Object.assign(this, partial);
      }
}