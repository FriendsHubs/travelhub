import Image from "next/image";

interface IInput {
  leadingImageUrl?: string;
  onChange: (e: any) => void;
}

export function Input({ leadingImageUrl, onChange }: any) {



  const LeadIcon = leadingImageUrl && (
    <div className="w-[21px] h-[21px] ml-[18px] mr-[18px]">
      <Image src={leadingImageUrl} layout="responsive" />
    </div>
  );

  return (
    <div className="w-full h-full bg-[#1F1F1F] flex items-center">
      {LeadIcon}
      <input
        className="w-full h-full bg-[#1F1F1F]  text-slate-300 outline-none"
        onChange={onChange}
        placeholder='Lorem ipsum'
      />
    </div>
  );
}
