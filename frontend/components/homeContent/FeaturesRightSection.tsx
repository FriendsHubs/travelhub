import { useState } from "react";
import { FeatureCard } from "./FeatureCard";
import { Accordion } from "./Accordion";
import arrowImage from "../../assets/image/arrow.png";
import questionImage from "../../assets/image/question.png";
import fourCircleImage from "../../assets/image/fourCircle.png";
import { AccordionHeader } from "./AccordionHeader";
import Image from "next/image";
import {v4 as UUID} from 'uuid'
interface IFeaturesRightSection {
  services: any[];
}

export function FeaturesRightSection({ services }: IFeaturesRightSection) {
  const [active, setActive] = useState(1);

  return (
    <div className="">
      <div className="mb-[24px]">
        <Accordion>
          <AccordionHeader
            LeadingImage={<Image src={fourCircleImage} layout="responsive" />}
            Title={
              <div className="flex items-center ">
                <p className="font-extrabold text-base mr-[6px]">Lorem</p>
                <div className="w-[13.9px] h-[13.5px] mr-[10px] ">
                  <Image src={questionImage} layout="responsive" />
                </div>
              </div>
            }
            TrailingImage={<Image src={arrowImage} layout="responsive" />}
          />
          <div className="pb-[48px] pl-[30px] pr-[49px]">
            <div className="w-full h-[320px] mt-[24px] overflow-y-auto ">
              <div className="grid lg:grid-cols-3 md:grid-cols-2 sm:grid-cols-3 gap-y-[10px] gap-x-[8px] ">
                {services.map((service, idx) => (
                  <FeatureCard
                  key={UUID()}
                    {...{
                      ...service,
                      isActive: active === idx,
                      selectCard: () => setActive(idx),
                    }}
                  />
                ))}
              </div>
            </div>
          </div>
        </Accordion>
      </div>
      <Accordion>
        <AccordionHeader
          LeadingImage={<Image src={fourCircleImage} layout="responsive" />}
          Title={<p className="font-extrabold text-base">Lorem</p>}
          TrailingImage={<Image src={arrowImage} layout="responsive" />}
        />
        <div></div>
      </Accordion>
    </div>
  );
}
